import cors from 'cors';
import dotenv from 'dotenv';
import express from 'express';
import PayOSPackage from '@payos/node';
import StripePackage from 'stripe';

dotenv.config();

const PayOS = PayOSPackage.PayOS || PayOSPackage.default || PayOSPackage;

const app = express();
const port = Number(process.env.PORT || 3000);

app.use(cors());
app.use(express.json());

const requiredEnv = [
  'PAYOS_CLIENT_ID',
  'PAYOS_API_KEY',
  'PAYOS_CHECKSUM_KEY',
];

function hasPayOsConfig() {
  return requiredEnv.every((key) => Boolean(process.env[key]));
}

function mask(value = '') {
  if (value.length <= 14) return '***';
  return `${value.slice(0, 8)}...${value.slice(-6)}`;
}

const payOS = hasPayOsConfig()
  ? new PayOS(
      process.env.PAYOS_CLIENT_ID,
      process.env.PAYOS_API_KEY,
      process.env.PAYOS_CHECKSUM_KEY,
    )
  : null;

const stripe = process.env.STRIPE_SECRET_KEY
  ? new StripePackage(process.env.STRIPE_SECRET_KEY, {
      apiVersion: '2023-10-16',
    })
  : null;

app.get('/health', (req, res) => {
  res.json({
    ok: true,
    payosConfigured: Boolean(payOS),
    stripeConfigured: Boolean(stripe),
  });
});

app.post('/create-payos-payment', async (req, res) => {
  if (!payOS) {
    return res.status(500).json({
      success: false,
      message: 'payOS env is missing. Check backend/.env.',
    });
  }

  try {
    const {
      orderCode,
      amount,
      description,
      buyerName,
      buyerEmail,
      buyerPhone,
      idUser,
      idTour,
    } = req.body || {};

    const normalizedAmount = Number(amount);
    if (!Number.isFinite(normalizedAmount) || normalizedAmount <= 0) {
      return res.status(400).json({
        success: false,
        message: 'amount must be a positive number',
      });
    }

    const normalizedOrderCode =
      Number.isInteger(Number(orderCode)) && Number(orderCode) > 0
        ? Number(orderCode)
        : Number(Date.now().toString().slice(-10));

    const shortDescription = String(description || 'Dat tour')
      .replace(/[^\p{L}\p{N}\s]/gu, '')
      .trim()
      .slice(0, 25) || 'Dat tour';

    console.log('[PAYOS] create payment', {
      orderCode: normalizedOrderCode,
      amount: normalizedAmount,
      description: shortDescription,
      buyerEmail,
      idUser,
      idTour,
      clientId: mask(process.env.PAYOS_CLIENT_ID),
    });

    const paymentLink = payOS.paymentRequests?.create
      ? await payOS.paymentRequests.create({
          orderCode: normalizedOrderCode,
          amount: Math.round(normalizedAmount),
          description: shortDescription,
          buyerName: String(buyerName || ''),
          buyerEmail: String(buyerEmail || ''),
          buyerPhone: String(buyerPhone || ''),
          items: [
            {
              name: shortDescription,
              quantity: 1,
              price: Math.round(normalizedAmount),
            },
          ],
          returnUrl: process.env.PAYOS_RETURN_URL || 'https://payos.vn',
          cancelUrl: process.env.PAYOS_CANCEL_URL || 'https://payos.vn',
        })
      : await payOS.createPaymentLink({
      orderCode: normalizedOrderCode,
      amount: Math.round(normalizedAmount),
      description: shortDescription,
      buyerName: String(buyerName || ''),
      buyerEmail: String(buyerEmail || ''),
      buyerPhone: String(buyerPhone || ''),
      items: [
        {
          name: shortDescription,
          quantity: 1,
          price: Math.round(normalizedAmount),
        },
      ],
      returnUrl: process.env.PAYOS_RETURN_URL || 'https://payos.vn',
      cancelUrl: process.env.PAYOS_CANCEL_URL || 'https://payos.vn',
    });

    return res.json({
      success: true,
      checkoutUrl: paymentLink.checkoutUrl,
      paymentLinkId: paymentLink.paymentLinkId || paymentLink.id || '',
      orderCode: normalizedOrderCode,
    });
  } catch (error) {
    console.error('[PAYOS][ERROR]', error?.message || error);
    return res.status(500).json({
      success: false,
      message: error?.message || 'Cannot create payOS payment link',
    });
  }
});

app.post('/create-stripe-payment-intent', async (req, res) => {
  if (!stripe) {
    return res.status(500).json({
      success: false,
      message: 'Stripe env is missing. Check STRIPE_SECRET_KEY in backend/.env.',
    });
  }

  try {
    const {
      amount,
      currency = 'vnd',
      description,
      buyerEmail,
      idUser,
      idTour,
    } = req.body || {};

    const normalizedAmount = Number(amount);
    if (!Number.isFinite(normalizedAmount) || normalizedAmount <= 0) {
      return res.status(400).json({
        success: false,
        message: 'amount must be a positive number',
      });
    }

    const normalizedCurrency = String(currency || 'vnd').toLowerCase();
    const shortDescription = String(description || 'Dat tour')
      .replace(/[^\p{L}\p{N}\s]/gu, '')
      .trim()
      .slice(0, 80) || 'Dat tour';

    console.log('[STRIPE] create payment intent', {
      amount: Math.round(normalizedAmount),
      currency: normalizedCurrency,
      buyerEmail,
      idUser,
      idTour,
      secretKey: mask(process.env.STRIPE_SECRET_KEY || ''),
    });

    const paymentIntent = await stripe.paymentIntents.create({
      amount: Math.round(normalizedAmount),
      currency: normalizedCurrency,
      description: shortDescription,
      receipt_email: buyerEmail || undefined,
      automatic_payment_methods: {
        enabled: true,
      },
      metadata: {
        idUser: String(idUser || ''),
        idTour: String(idTour || ''),
      },
    });

    return res.json({
      success: true,
      clientSecret: paymentIntent.client_secret,
      paymentIntentId: paymentIntent.id,
      amount: paymentIntent.amount,
      currency: paymentIntent.currency,
    });
  } catch (error) {
    console.error('[STRIPE][ERROR]', error?.message || error);
    return res.status(500).json({
      success: false,
      message: error?.message || 'Cannot create Stripe PaymentIntent',
    });
  }
});

app.listen(port, '0.0.0.0', () => {
  console.log(`[PAYOS] backend listening on http://0.0.0.0:${port}`);
  console.log(`[PAYOS] clientId ${mask(process.env.PAYOS_CLIENT_ID || '')}`);
  console.log(`[STRIPE] configured ${Boolean(stripe)}`);
});
