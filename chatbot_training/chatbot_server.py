import argparse
import json
import re
import unicodedata
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from typing import Any, Dict, List, Tuple


DEFAULT_HOST = "0.0.0.0"
DEFAULT_PORT = 5055
PROJECT_ROOT = Path(__file__).resolve().parents[1]
DEFAULT_KNOWLEDGE_PATH = PROJECT_ROOT / "assets" / "chatbot" / "chatbot_knowledge_base.json"


def normalize(text: str) -> str:
    value = unicodedata.normalize("NFD", text.lower())
    value = "".join(ch for ch in value if unicodedata.category(ch) != "Mn")
    value = value.replace("đ", "d")
    value = re.sub(r"\s+", " ", value)
    return value.strip()


def load_knowledge(path: Path) -> Dict[str, Any]:
    if not path.exists():
        raise SystemExit(f"Knowledge file not found: {path}")
    return json.loads(path.read_text(encoding="utf-8"))


def money(value: Any) -> str:
    try:
        amount = float(value)
    except (TypeError, ValueError):
        return "đang cập nhật"
    return f"{amount:,.0f} VND".replace(",", ".")


class TravelChatbot:
    def __init__(self, knowledge: Dict[str, Any]):
        self.knowledge = knowledge
        self.scope_answer = knowledge.get("scope", {}).get(
            "outOfScopeAnswer",
            "Mình chỉ hỗ trợ các câu hỏi về app Travel Booking.",
        )
        self.allowed_keywords = [
            "tour",
            "du lich",
            "diem den",
            "dat tour",
            "booking",
            "thanh toan",
            "payos",
            "qr",
            "banking",
            "visa",
            "stripe",
            "history",
            "lich su",
            "yeu thich",
            "favorite",
            "firebase",
            "firestore",
            "database",
            "da lat",
            "da nang",
            "nha trang",
            "phu quoc",
            "hoi an",
            "ha noi",
            "hue",
            "sapa",
        ]

    def answer(self, message: str) -> Dict[str, Any]:
        normalized = normalize(message)
        if not self._in_scope(normalized):
            return {
                "success": True,
                "inScope": False,
                "answer": self.scope_answer,
                "source": "scope/out_of_scope",
            }

        answer, source, tour = self._answer_in_scope(normalized)
        return {
            "success": True,
            "inScope": True,
            "answer": answer,
            "source": source,
            "tour": tour,
        }

    def _in_scope(self, normalized: str) -> bool:
        return any(keyword in normalized for keyword in self.allowed_keywords)

    def _answer_in_scope(self, normalized: str) -> Tuple[str, str, Dict[str, Any] | None]:
        tour = self._match_tour(normalized)
        if tour:
            if any(word in normalized for word in ["gia", "bao nhieu", "tien"]):
                return (
                    f"{tour['name']} có giá khoảng {money(tour.get('price'))}. "
                    f"Thời lượng: {tour.get('duration', 'đang cập nhật')}.",
                    f"tour/{tour.get('id')}",
                    tour,
                )
            if any(word in normalized for word in ["thanh toan", "payos", "visa", "stripe", "qr"]):
                return (
                    f"{tour['name']} có thể thanh toán bằng {tour.get('payment', 'payOS hoặc Visa test mode')}.",
                    f"tour/{tour.get('id')}",
                    tour,
                )
            return (
                f"{tour['name']} ở {tour.get('location', 'đang cập nhật')}, "
                f"thời lượng {tour.get('duration', 'đang cập nhật')}, giá {money(tour.get('price'))}.",
                f"tour/{tour.get('id')}",
                tour,
            )

        city = self._match_city(normalized)
        if city:
            return (
                f"{city['name']}: {city.get('description', 'Chưa có mô tả.')}",
                f"city/{city.get('id')}",
                None,
            )

        if any(word in normalized for word in ["dat", "booking", "book"]):
            return (
                "Bạn mở chi tiết tour, bấm Book Tour, chọn số người, kiểm tra tổng tiền rồi chọn phương thức thanh toán.",
                "faq/booking",
                None,
            )

        if any(word in normalized for word in ["thanh toan", "payos", "qr", "banking", "visa", "stripe"]):
            return (
                "App hỗ trợ QR/banking qua payOS và Visa test mode qua Stripe. Nếu lỗi kết nối, hãy kiểm tra backend local, IP LAN và endpoint /health.",
                "faq/payment",
                None,
            )

        if any(word in normalized for word in ["history", "lich su"]):
            return (
                "Bạn mở tab History để xem các booking đang chờ, sắp diễn ra, đang diễn ra, đã hoàn thành hoặc đã hủy.",
                "faq/history",
                None,
            )

        if any(word in normalized for word in ["yeu thich", "favorite"]):
            return (
                "Tour yêu thích lưu trong userModel/{userDocId}/favouriteTour, còn city yêu thích lưu trong userModel/{userDocId}/favourite.",
                "faq/favorite",
                None,
            )

        if any(word in normalized for word in ["firebase", "firestore", "database"]):
            collections = ", ".join(self.knowledge.get("firestoreCollections", []))
            return (
                f"Project dùng Firestore cho các collection/subcollection chính: {collections}.",
                "faq/firestore",
                None,
            )

        return (
            "Bạn có thể hỏi mình về tour, điểm đến, đặt tour, thanh toán, lịch sử booking hoặc yêu thích.",
            "faq/general",
            None,
        )

    def _match_tour(self, normalized: str):
        city_by_id = {city.get("id"): city for city in self.knowledge.get("cities", [])}
        for tour in self.knowledge.get("tours", []):
            name = normalize(tour.get("name", ""))
            location = normalize(tour.get("location", ""))
            city_name = normalize(city_by_id.get(tour.get("cityId"), {}).get("name", ""))
            if name and name in normalized:
                return tour
            if location and location in normalized:
                return tour
            if city_name and city_name in normalized:
                return tour
        return None

    def _match_city(self, normalized: str):
        for city in self.knowledge.get("cities", []):
            name = normalize(city.get("name", ""))
            if name and name in normalized:
                return city
        return None


def make_handler(bot: TravelChatbot):
    class ChatbotHandler(BaseHTTPRequestHandler):
        def _send_json(self, status: int, payload: Dict[str, Any]):
            body = json.dumps(payload, ensure_ascii=False).encode("utf-8")
            self.send_response(status)
            self.send_header("Content-Type", "application/json; charset=utf-8")
            self.send_header("Access-Control-Allow-Origin", "*")
            self.send_header("Access-Control-Allow-Headers", "Content-Type")
            self.send_header("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
            self.send_header("Content-Length", str(len(body)))
            self.end_headers()
            self.wfile.write(body)

        def do_OPTIONS(self):
            self._send_json(200, {"ok": True})

        def do_GET(self):
            if self.path == "/health":
                self._send_json(
                    200,
                    {
                        "ok": True,
                        "service": "travel-chatbot",
                        "scope": bot.knowledge.get("scope", {}).get("allowedTopics", []),
                    },
                )
                return
            self._send_json(404, {"success": False, "message": "Not found"})

        def do_POST(self):
            if self.path != "/chat":
                self._send_json(404, {"success": False, "message": "Not found"})
                return

            length = int(self.headers.get("Content-Length", "0"))
            raw_body = self.rfile.read(length).decode("utf-8")
            try:
                body = json.loads(raw_body) if raw_body else {}
            except json.JSONDecodeError:
                self._send_json(400, {"success": False, "message": "Invalid JSON"})
                return

            message = str(body.get("message", "")).strip()
            if not message:
                self._send_json(400, {"success": False, "message": "Missing message"})
                return

            response = bot.answer(message)
            print(
                f"[CHATBOT_SERVER] message={message!r} inScope={response.get('inScope')} source={response.get('source')}"
            )
            self._send_json(200, response)

        def log_message(self, format, *args):
            return

    return ChatbotHandler


def parse_args():
    parser = argparse.ArgumentParser(description="Local chatbot server for Flutter Travel Booking.")
    parser.add_argument("--host", default=DEFAULT_HOST)
    parser.add_argument("--port", type=int, default=DEFAULT_PORT)
    parser.add_argument("--knowledge", default=str(DEFAULT_KNOWLEDGE_PATH))
    return parser.parse_args()


def main():
    args = parse_args()
    knowledge = load_knowledge(Path(args.knowledge))
    bot = TravelChatbot(knowledge)
    server = ThreadingHTTPServer((args.host, args.port), make_handler(bot))
    print(f"[CHATBOT_SERVER] Listening on http://{args.host}:{args.port}")
    print(f"[CHATBOT_SERVER] Knowledge: {Path(args.knowledge).resolve()}")
    server.serve_forever()


if __name__ == "__main__":
    main()
