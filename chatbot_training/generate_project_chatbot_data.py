import json
from pathlib import Path
from typing import Any, Dict, List


PROJECT_ROOT = Path(__file__).resolve().parents[1]
OUTPUT_DIR = Path(__file__).resolve().parent / "output"
FLUTTER_ASSET_DIR = PROJECT_ROOT / "assets" / "chatbot"


def money(value: int) -> str:
    return f"{value:,.0f} VND".replace(",", ".")


def build_knowledge_base() -> Dict[str, Any]:
    cities = [
        {
            "id": "city_01",
            "name": "Đà Lạt",
            "description": "Thành phố ngàn hoa, khí hậu mát mẻ, phù hợp nghỉ dưỡng và check-in.",
        },
        {
            "id": "city_02",
            "name": "Đà Nẵng",
            "description": "Thành phố biển hiện đại với cầu Rồng, biển Mỹ Khê và Bà Nà Hills.",
        },
        {
            "id": "city_03",
            "name": "Nha Trang",
            "description": "Điểm đến biển đảo, hải sản và hoạt động vui chơi ven biển.",
        },
        {
            "id": "city_04",
            "name": "Phú Quốc",
            "description": "Đảo ngọc với biển xanh, resort và nhiều điểm nghỉ dưỡng.",
        },
        {
            "id": "city_05",
            "name": "Hội An",
            "description": "Phố cổ yên bình, nổi bật với đèn lồng và văn hóa truyền thống.",
        },
        {
            "id": "city_06",
            "name": "Hà Nội",
            "description": "Thủ đô nghìn năm văn hiến với phố cổ, hồ Gươm và ẩm thực đặc trưng.",
        },
        {
            "id": "city_07",
            "name": "Huế",
            "description": "Cố đô với Đại Nội, lăng tẩm, sông Hương và ẩm thực cung đình.",
        },
        {
            "id": "city_08",
            "name": "Sapa",
            "description": "Thị trấn vùng cao với ruộng bậc thang, Fansipan và bản làng dân tộc.",
        },
    ]

    tours = [
        {
            "id": "tour_01",
            "name": "Tour Đà Lạt 3 ngày 2 đêm",
            "cityId": "city_01",
            "location": "Đà Lạt, Lâm Đồng",
            "duration": "3 ngày 2 đêm",
            "price": 2500000,
            "image": "assets/images/x2/des1.jpg",
            "description": "Khám phá hồ Xuân Hương, chợ đêm, thung lũng Tình Yêu và các điểm check-in nổi tiếng.",
            "payment": "payOS QR, banking hoặc Visa test mode qua Stripe",
        },
        {
            "id": "tour_02",
            "name": "Tour Đà Nẵng - Hội An 4 ngày 3 đêm",
            "cityId": "city_02",
            "location": "Đà Nẵng",
            "duration": "4 ngày 3 đêm",
            "price": 3200000,
            "image": "assets/images/x2/des4.jpg",
            "description": "Trải nghiệm biển Mỹ Khê, cầu Rồng, Bà Nà Hills và phố cổ Hội An về đêm.",
            "payment": "payOS QR, banking hoặc Visa test mode qua Stripe",
        },
        {
            "id": "tour_03",
            "name": "Tour Phú Quốc nghỉ dưỡng 3 ngày 2 đêm",
            "cityId": "city_04",
            "location": "Phú Quốc, Kiên Giang",
            "duration": "3 ngày 2 đêm",
            "price": 4500000,
            "image": "assets/images/x2/des7.jpg",
            "description": "Nghỉ dưỡng tại đảo ngọc, tham quan biển xanh, cáp treo Hòn Thơm và thưởng thức hải sản.",
            "payment": "payOS QR, banking hoặc Visa test mode qua Stripe",
        },
        {
            "id": "tour_04",
            "name": "Tour Nha Trang biển đảo 3 ngày 2 đêm",
            "cityId": "city_03",
            "location": "Nha Trang, Khánh Hòa",
            "duration": "3 ngày 2 đêm",
            "price": 2900000,
            "image": "assets/images/x2/des2.png",
            "description": "Khám phá biển đảo Nha Trang, VinWonders, chợ đêm và các món hải sản đặc trưng.",
            "payment": "payOS QR, banking hoặc Visa test mode qua Stripe",
        },
        {
            "id": "tour_05",
            "name": "Tour Hội An 2 ngày 1 đêm",
            "cityId": "city_05",
            "location": "Hội An, Quảng Nam",
            "duration": "2 ngày 1 đêm",
            "price": 1800000,
            "image": "assets/images/x2/des5.jpg",
            "description": "Dạo phố cổ Hội An, thả đèn hoa đăng, thưởng thức ẩm thực địa phương và tham quan làng nghề.",
            "payment": "payOS QR, banking hoặc Visa test mode qua Stripe",
        },
        {
            "id": "tour_06",
            "name": "Tour Hà Nội - Ninh Bình 3 ngày 2 đêm",
            "cityId": "city_06",
            "location": "Hà Nội",
            "duration": "3 ngày 2 đêm",
            "price": 3100000,
            "image": "assets/images/x2/des8.jpg",
            "description": "Tham quan phố cổ Hà Nội, hồ Gươm, Tràng An, Bái Đính và cảnh đẹp non nước Ninh Bình.",
            "payment": "payOS QR, banking hoặc Visa test mode qua Stripe",
        },
        {
            "id": "tour_07",
            "name": "Tour Huế di sản 2 ngày 1 đêm",
            "cityId": "city_07",
            "location": "Huế, Thừa Thiên Huế",
            "duration": "2 ngày 1 đêm",
            "price": 1900000,
            "image": "assets/images/x2/des3.jpg",
            "description": "Tham quan Đại Nội, lăng vua, chùa Thiên Mụ và thưởng thức ẩm thực cung đình Huế.",
            "payment": "payOS QR, banking hoặc Visa test mode qua Stripe",
        },
        {
            "id": "tour_08",
            "name": "Tour Sapa - Fansipan 3 ngày 2 đêm",
            "cityId": "city_08",
            "location": "Sapa, Lào Cai",
            "duration": "3 ngày 2 đêm",
            "price": 3600000,
            "image": "assets/images/x2/des6.jpg",
            "description": "Khám phá Sapa, bản Cát Cát, núi Hàm Rồng, ruộng bậc thang và chinh phục Fansipan.",
            "payment": "payOS QR, banking hoặc Visa test mode qua Stripe",
        },
    ]

    scope = {
        "allowedTopics": [
            "tour",
            "điểm đến",
            "đặt tour",
            "booking",
            "thanh toán",
            "payOS",
            "Stripe",
            "Visa",
            "lịch sử booking",
            "yêu thích",
            "Firebase",
            "Firestore",
        ],
        "outOfScopeAnswer": (
            "Mình chỉ hỗ trợ các câu hỏi về app Travel Booking như tour, đặt tour, "
            "thanh toán, lịch sử booking, yêu thích và dữ liệu Firebase."
        ),
    }

    faq = [
        {
            "question": "Làm sao để đặt tour?",
            "answer": "Bạn mở chi tiết tour, bấm Book Tour, chọn số người, kiểm tra tổng tiền rồi chọn phương thức thanh toán.",
        },
        {
            "question": "App thanh toán bằng gì?",
            "answer": "App hỗ trợ QR/banking qua payOS và Visa test mode qua Stripe nếu backend local đã chạy.",
        },
        {
            "question": "Vì sao không kết nối được cổng thanh toán?",
            "answer": "Hãy kiểm tra backend local, IP LAN trong Flutter, firewall Windows và endpoint /health của backend.",
        },
        {
            "question": "Xem lịch sử đặt tour ở đâu?",
            "answer": "Bạn mở tab History để xem booking đang chờ, sắp diễn ra, đang diễn ra, đã hoàn thành hoặc đã hủy.",
        },
        {
            "question": "Yêu thích tour lưu ở đâu?",
            "answer": "Tour yêu thích lưu trong userModel/{userDocId}/favouriteTour, còn city yêu thích lưu trong userModel/{userDocId}/favourite.",
        },
    ]

    return {
        "project": "Flutter Travel Booking GetX",
        "language": "vi",
        "scope": scope,
        "cities": cities,
        "tours": tours,
        "faq": faq,
        "firestoreCollections": [
            "cityModel",
            "tourModel",
            "userModel",
            "historyModel",
            "favourite",
            "favouriteTour",
            "videos",
            "comments",
            "searchTour",
            "pushNotification",
        ],
    }


def build_training_rows(knowledge: Dict[str, Any]) -> List[Dict[str, Any]]:
    rows: List[Dict[str, Any]] = []
    system = (
        "Bạn là chatbot hỗ trợ app Flutter Travel Booking. "
        "Chỉ trả lời về tour, booking, thanh toán, history, favorite và Firebase của project."
    )

    def add(question: str, answer: str, source: str):
        rows.append(
            {
                "messages": [
                    {"role": "system", "content": system},
                    {"role": "user", "content": question},
                    {"role": "assistant", "content": answer},
                ],
                "source": source,
            }
        )

    for city in knowledge["cities"]:
        add(
            f"Giới thiệu {city['name']}",
            f"{city['name']}: {city['description']}",
            f"city/{city['id']}",
        )

    for tour in knowledge["tours"]:
        add(
            f"{tour['name']} giá bao nhiêu?",
            f"{tour['name']} có giá khoảng {money(tour['price'])}, thời lượng {tour['duration']}, địa điểm {tour['location']}.",
            f"tour/{tour['id']}",
        )
        add(
            f"Thanh toán {tour['name']} như thế nào?",
            f"Bạn có thể thanh toán {tour['name']} bằng {tour['payment']}.",
            f"tour/{tour['id']}",
        )

    for item in knowledge["faq"]:
        add(item["question"], item["answer"], "faq")

    add(
        "Hỏi về bóng đá được không?",
        knowledge["scope"]["outOfScopeAnswer"],
        "scope/out_of_scope",
    )

    return rows


def write_json(path: Path, data: Any):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding="utf-8")


def write_jsonl(path: Path, rows: List[Dict[str, Any]]):
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as file:
        for row in rows:
            file.write(json.dumps(row, ensure_ascii=False) + "\n")


def main():
    knowledge = build_knowledge_base()
    rows = build_training_rows(knowledge)

    write_json(OUTPUT_DIR / "chatbot_knowledge_base.json", knowledge)
    write_jsonl(OUTPUT_DIR / "chatbot_training.jsonl", rows)
    write_json(FLUTTER_ASSET_DIR / "chatbot_knowledge_base.json", knowledge)

    print(f"[CHATBOT_DATA] Wrote {OUTPUT_DIR / 'chatbot_knowledge_base.json'}")
    print(f"[CHATBOT_DATA] Wrote {OUTPUT_DIR / 'chatbot_training.jsonl'}")
    print(f"[CHATBOT_DATA] Wrote {FLUTTER_ASSET_DIR / 'chatbot_knowledge_base.json'}")
    print(f"[CHATBOT_DATA] Training rows: {len(rows)}")


if __name__ == "__main__":
    main()
