# Chatbot Training Data Tool

Tool Python này đọc dữ liệu Firestore của app Travel Booking và xuất dữ liệu tiếng Việt để xây dựng chatbot.

## Không commit file nhạy cảm

Không đưa service account Firebase vào Git. Các file như `serviceAccountKey.json`, `firebase-adminsdk*.json` và dữ liệu sinh ra trong `chatbot_training/output/` đã được ignore.

## Cài đặt

```powershell
cd chatbot_training
python -m venv .venv
.\.venv\Scripts\Activate.ps1
pip install -r requirements.txt
```

## Chuẩn bị Firebase service account

Vào Firebase Console:

Project settings -> Service accounts -> Generate new private key

Lưu file JSON vào máy local, ví dụ:

```text
C:\Users\pdhhi\Downloads\firebase-service-account.json
```

## Chạy export

```powershell
python export_firestore_training_data.py --service-account "C:\Users\pdhhi\Downloads\firebase-service-account.json"
```

Hoặc dùng biến môi trường:

```powershell
$env:GOOGLE_APPLICATION_CREDENTIALS="C:\Users\pdhhi\Downloads\firebase-service-account.json"
python export_firestore_training_data.py
```

## Output

Tool tạo trong `chatbot_training/output/`:

- `chatbot_training.jsonl`: dữ liệu hỏi/đáp dạng JSONL.
- `chatbot_knowledge_base.json`: knowledge base có cấu trúc theo collection.

## Sinh data demo cho Flutter

Nếu chưa có service account Firebase, có thể sinh data demo đúng chủ đề project:

```powershell
python generate_project_chatbot_data.py
```

Lệnh này tạo:

- `chatbot_training/output/chatbot_knowledge_base.json`
- `chatbot_training/output/chatbot_training.jsonl`
- `assets/chatbot/chatbot_knowledge_base.json`

## Chạy chatbot server local

```powershell
cd chatbot_training
.\run_chatbot_server.ps1
```

Server chạy ở:

```text
http://localhost:5055
```

Kiểm tra:

```powershell
Invoke-RestMethod http://localhost:5055/health
Invoke-RestMethod http://localhost:5055/chat -Method Post -ContentType "application/json" -Body '{"message":"Tour Đà Lạt giá bao nhiêu?"}'
```

Khi chạy trên điện thoại Android thật, Flutter cần dùng IP LAN của máy tính:

```powershell
fvm flutter run -d 25e53b9e12057ece --dart-define=CHATBOT_BACKEND_URL=http://<IP-LAN>:5055 --no-resident
```

Nếu server không chạy hoặc điện thoại không kết nối được, Flutter sẽ tự fallback sang `assets/chatbot/chatbot_knowledge_base.json`.

## Phạm vi câu hỏi

Chatbot chỉ trả lời các chủ đề:

- tour, điểm đến, giá tour
- đặt tour/booking
- thanh toán payOS, QR, Banking, Visa/Stripe
- lịch sử booking
- yêu thích
- Firebase/Firestore của project

Câu hỏi ngoài phạm vi sẽ được từ chối nhẹ nhàng.

## Collection đang đọc

- `cityModel`
- `tourModel`
- `searchTour`
- `videos`

Có thể thêm collection:

```powershell
python export_firestore_training_data.py --collections cityModel tourModel historyModel
```

## Gợi ý dùng dữ liệu

- Dùng `chatbot_training.jsonl` để fine-tune hoặc nạp vào hệ thống RAG.
- Dùng `chatbot_knowledge_base.json` để debug dữ liệu và xây dựng intent/FAQ.
- Với dữ liệu người dùng thật như `userModel` hoặc `historyModel`, cần lọc thông tin cá nhân trước khi huấn luyện.
