# payOS Local Backend

Backend local nay dung de tao payment link payOS cho app Flutter Travel Booking.
Secret payOS chi nam trong `backend/.env`, khong dua vao Flutter app.
Stripe secret key cung chi nam trong `backend/.env`, khong dua vao Flutter app.

## Cai dat

```powershell
cd backend
npm install
```

## Cau hinh

Tao `backend/.env` theo mau `backend/.env.example`:

```env
PAYOS_CLIENT_ID=your_payos_client_id
PAYOS_API_KEY=your_payos_api_key
PAYOS_CHECKSUM_KEY=your_payos_checksum_key
STRIPE_SECRET_KEY=your_stripe_secret_key
PORT=3000
PAYOS_RETURN_URL=https://payos.vn
PAYOS_CANCEL_URL=https://payos.vn
```

Khong commit `backend/.env`.

## Chay backend

```powershell
cd backend
npm run dev
```

Health check:

```powershell
Invoke-RestMethod http://localhost:3000/health
```

## Cau hinh Flutter backend URL

File Flutter dang dung:

`lib/shared/services/payos_payment_service.dart`

Khi chay tren dien thoai Android that, khong dung `localhost`.
Hay doi sang IP LAN cua may dang chay backend, vi du:

`http://192.168.1.10:3000`

Hoac chay Flutter voi dart-define:

```powershell
fvm flutter run -d 25e53b9e12057ece --dart-define=PAYOS_BACKEND_URL=http://192.168.1.10:3000
```

## Endpoint

`GET /health`

Tra ve:

```json
{ "ok": true, "payosConfigured": true }
```

`POST /create-payos-payment`

Body:

```json
{
  "orderCode": 123456,
  "amount": 2500000,
  "description": "Dat tour",
  "buyerName": "Nguyen Van A",
  "buyerEmail": "a@example.com",
  "buyerPhone": "0123456789",
  "idUser": "user_id",
  "idTour": "tour_01"
}
```

Response thanh cong:

```json
{
  "success": true,
  "checkoutUrl": "https://...",
  "paymentLinkId": "...",
  "orderCode": 123456
}
```

`POST /create-stripe-payment-intent`

Body:

```json
{
  "amount": 2500000,
  "currency": "vnd",
  "description": "Dat tour",
  "buyerEmail": "a@example.com",
  "idUser": "user_id",
  "idTour": "tour_01"
}
```

Response thanh cong:

```json
{
  "success": true,
  "clientSecret": "pi_..._secret_...",
  "paymentIntentId": "pi_...",
  "amount": 2500000,
  "currency": "vnd"
}
```

## Stripe test mode

- Lay `STRIPE_SECRET_KEY` trong Stripe Dashboard -> Developers -> API keys.
- Chi dien `sk_test...` vao `backend/.env`.
- Flutter chi dung publishable key `pk_test...` trong `lib/main.dart`.
- Khong commit `backend/.env`.
- The test Stripe:
  - So the: `4242 4242 4242 4242`
  - Ngay het han: ngay tuong lai
  - CVC: `123`
