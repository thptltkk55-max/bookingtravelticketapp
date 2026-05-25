$ErrorActionPreference = "Stop"

$FlutterVersion = "3.10.5"
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $Root

if (-not (Test-Path -LiteralPath "pubspec.yaml")) {
    Write-Host "pubspec.yaml not found. Open the project root folder first."
    exit 1
}

if (-not (Get-Command fvm -ErrorAction SilentlyContinue)) {
    Write-Host "FVM is not installed or not in PATH."
    Write-Host "Install it with:"
    Write-Host "dart pub global activate fvm"
    exit 1
}

$portableJdkRoot = Join-Path $env:USERPROFILE ".jdks"
if (Test-Path -LiteralPath $portableJdkRoot) {
    $portableJdk = Get-ChildItem -LiteralPath $portableJdkRoot -Directory |
        Where-Object { Test-Path (Join-Path $_.FullName "bin\java.exe") } |
        Sort-Object Name -Descending |
        Select-Object -First 1

    if ($portableJdk) {
        $env:JAVA_HOME = $portableJdk.FullName
        $env:Path = "$env:JAVA_HOME\bin;$env:Path"
        Write-Host "Using local JDK: $env:JAVA_HOME"
    }
}

Write-Host "Using Flutter $FlutterVersion through FVM..."
fvm install $FlutterVersion
fvm use $FlutterVersion --force

$localTargets = @(
    "android/local.properties",
    ".dart_tool",
    "build",
    ".flutter-plugins",
    ".flutter-plugins-dependencies"
)

foreach ($target in $localTargets) {
    if (Test-Path -LiteralPath $target) {
        Write-Host "Removing $target"
        Remove-Item -LiteralPath $target -Recurse -Force
    }
}

fvm flutter clean
fvm flutter pub get
fvm flutter doctor -v

Write-Host ""
Write-Host "Run app:"
Write-Host "fvm flutter run"
Write-Host ""
Write-Host "Build debug APK:"
Write-Host "fvm flutter build apk --debug"
