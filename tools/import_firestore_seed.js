'use strict';

const fs = require('fs');
const path = require('path');
const seed = require('./firestore_seed_data');

const args = new Set(process.argv.slice(2));
const dryRun = args.has('--dry-run');
const yes = args.has('--yes');

function printUsage() {
  console.log('Usage:');
  console.log('  node tools/import_firestore_seed.js --dry-run');
  console.log('  node tools/import_firestore_seed.js --yes');
  console.log('');
  console.log('Environment:');
  console.log('  GOOGLE_APPLICATION_CREDENTIALS=C:\\path\\to\\serviceAccountKey.json');
  console.log('  or FIREBASE_SERVICE_ACCOUNT=C:\\path\\to\\serviceAccountKey.json');
  console.log('  optional FIREBASE_PROJECT_ID=your-project-id');
}

function validateDocPath(writePath) {
  const parts = writePath.split('/').filter(Boolean);
  if (parts.length < 2 || parts.length % 2 !== 0) {
    throw new Error(`Invalid Firestore document path: ${writePath}`);
  }
}

function convertSpecialValues(value, admin) {
  if (Array.isArray(value)) {
    return value.map((item) => convertSpecialValues(item, admin));
  }

  if (value && typeof value === 'object') {
    if (value.__type === 'timestamp') {
      return admin.firestore.Timestamp.fromDate(new Date(value.value));
    }

    return Object.fromEntries(
      Object.entries(value).map(([key, childValue]) => [
        key,
        convertSpecialValues(childValue, admin),
      ]),
    );
  }

  return value;
}

function summarize(writes) {
  const byCollection = {};

  for (const write of writes) {
    validateDocPath(write.path);
    const collection = write.path.split('/')[0];
    byCollection[collection] = (byCollection[collection] || 0) + 1;
  }

  console.log(`Seed: ${seed.metadata.name}`);
  console.log(`Locale: ${seed.metadata.locale}`);
  console.log(`Media mode: ${seed.metadata.mediaMode}`);
  console.log(`Total writes: ${writes.length}`);
  console.log('Writes by top collection:');

  for (const [collection, count] of Object.entries(byCollection)) {
    console.log(`  - ${collection}: ${count}`);
  }

  console.log('Sample paths:');
  for (const write of writes.slice(0, 8)) {
    console.log(`  - ${write.path}`);
  }
}

function loadServiceAccount() {
  const serviceAccountPath =
    process.env.GOOGLE_APPLICATION_CREDENTIALS ||
    process.env.FIREBASE_SERVICE_ACCOUNT;

  if (!serviceAccountPath) {
    throw new Error(
      'Missing GOOGLE_APPLICATION_CREDENTIALS or FIREBASE_SERVICE_ACCOUNT.',
    );
  }

  const resolvedPath = path.resolve(serviceAccountPath);
  if (!fs.existsSync(resolvedPath)) {
    throw new Error(`Service account file not found: ${resolvedPath}`);
  }

  return {
    path: resolvedPath,
    json: require(resolvedPath),
  };
}

async function main() {
  const writes = seed.buildWrites();
  summarize(writes);

  if (dryRun) {
    console.log('');
    console.log('Dry-run only. No data was written to Firestore.');
    return;
  }

  if (!yes) {
    console.log('');
    console.log('No data was written. Add --yes to upsert this seed to Firestore.');
    printUsage();
    process.exitCode = 1;
    return;
  }

  let admin;
  try {
    admin = require('firebase-admin');
  } catch (error) {
    throw new Error(
      'Missing dependency firebase-admin. Run `npm install` before importing.',
    );
  }

  const serviceAccount = loadServiceAccount();
  const projectId =
    process.env.FIREBASE_PROJECT_ID || serviceAccount.json.project_id;

  if (!projectId) {
    throw new Error(
      'Missing Firebase project id. Set FIREBASE_PROJECT_ID or use a valid service account.',
    );
  }

  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount.json),
    projectId,
  });

  const db = admin.firestore();
  const batchSize = 450;

  for (let index = 0; index < writes.length; index += batchSize) {
    const chunk = writes.slice(index, index + batchSize);
    const batch = db.batch();

    for (const write of chunk) {
      batch.set(
        db.doc(write.path),
        convertSpecialValues(write.data, admin),
        { merge: true },
      );
    }

    await batch.commit();
    console.log(`Committed ${index + chunk.length}/${writes.length}`);
  }

  console.log('');
  console.log(`Done. Firestore project: ${projectId}`);
  console.log('Data was upserted safely with merge=true.');
}

main().catch((error) => {
  console.error('');
  console.error('Import failed:');
  console.error(error.message || error);
  process.exitCode = 1;
});
