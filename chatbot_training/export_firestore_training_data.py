import argparse
import json
import os
from datetime import datetime, timezone
from pathlib import Path
from typing import Any, Dict, Iterable, List

import firebase_admin
from firebase_admin import credentials, firestore


DEFAULT_COLLECTIONS = ["cityModel", "tourModel", "searchTour", "videos"]


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Export Firestore data to Vietnamese chatbot training files."
    )
    parser.add_argument(
        "--service-account",
        help="Path to Firebase service account JSON. If omitted, GOOGLE_APPLICATION_CREDENTIALS is used.",
    )
    parser.add_argument(
        "--project-id",
        help="Optional Firebase project id override.",
    )
    parser.add_argument(
        "--output-dir",
        default="output",
        help="Output folder. Default: chatbot_training/output",
    )
    parser.add_argument(
        "--collections",
        nargs="+",
        default=DEFAULT_COLLECTIONS,
        help="Firestore collections to export.",
    )
    return parser.parse_args()


def init_firestore(service_account: str | None, project_id: str | None):
    credential_path = service_account or os.environ.get("GOOGLE_APPLICATION_CREDENTIALS")
    if not credential_path:
        raise SystemExit(
            "Missing service account. Use --service-account or GOOGLE_APPLICATION_CREDENTIALS."
        )

    cred = credentials.Certificate(credential_path)
    options = {"projectId": project_id} if project_id else None
    if not firebase_admin._apps:
        firebase_admin.initialize_app(cred, options)
    return firestore.client()


def normalize_value(value: Any) -> Any:
    if isinstance(value, datetime):
        return value.astimezone(timezone.utc).isoformat()
    if hasattr(value, "to_datetime"):
        return value.to_datetime().astimezone(timezone.utc).isoformat()
    if isinstance(value, list):
        return [normalize_value(item) for item in value]
    if isinstance(value, dict):
        return {key: normalize_value(item) for key, item in value.items()}
    return value


def fetch_collection(db, collection_name: str) -> List[Dict[str, Any]]:
    documents = []
    for doc in db.collection(collection_name).stream():
        data = doc.to_dict() or {}
        data = normalize_value(data)
        data["_docId"] = doc.id
        documents.append(data)
    return documents


def text(value: Any, default: str = "") -> str:
    if value is None:
        return default
    return str(value).strip()


def money(value: Any) -> str:
    try:
        amount = float(value)
    except (TypeError, ValueError):
        return "đang cập nhật"
    return f"{amount:,.0f} VND".replace(",", ".")


def first_image(images: Any) -> str:
    if isinstance(images, list) and images:
        return text(images[0])
    return ""


def add_pair(records: List[Dict[str, str]], prompt: str, completion: str, source: str):
    prompt = prompt.strip()
    completion = completion.strip()
    if not prompt or not completion:
        return
    records.append(
        {
            "messages": [
                {
                    "role": "system",
                    "content": "Bạn là chatbot hỗ trợ app đặt tour du lịch, trả lời ngắn gọn bằng tiếng Việt.",
                },
                {"role": "user", "content": prompt},
                {"role": "assistant", "content": completion},
            ],
            "source": source,
        }
    )


def build_training_records(knowledge_base: Dict[str, List[Dict[str, Any]]]):
    records: List[Dict[str, str]] = []

    for city in knowledge_base.get("cityModel", []):
        name = text(city.get("nameCity"))
        description = text(city.get("descriptionCity"), "Chưa có mô tả.")
        doc_id = text(city.get("_docId"))
        image = text(city.get("imageCity"))

        add_pair(
            records,
            f"Giới thiệu về {name}",
            f"{name} là điểm đến trong app. {description}",
            f"cityModel/{doc_id}",
        )
        add_pair(
            records,
            f"{name} có ảnh đại diện nào?",
            f"Ảnh đại diện của {name} đang lưu ở: {image or 'đang cập nhật'}.",
            f"cityModel/{doc_id}",
        )

    for tour in knowledge_base.get("tourModel", []):
        name = text(tour.get("nameTour"))
        doc_id = text(tour.get("_docId"))
        location = text(tour.get("location"), "đang cập nhật")
        duration = text(tour.get("duration"), "đang cập nhật")
        accommodation = text(tour.get("accommodation"), "đang cập nhật")
        price = money(tour.get("price"))
        rating = text(tour.get("rating"), "chưa có")
        image = first_image(tour.get("images"))

        add_pair(
            records,
            f"Tour {name} giá bao nhiêu?",
            f"Tour {name} có giá khoảng {price}. Thời lượng: {duration}.",
            f"tourModel/{doc_id}",
        )
        add_pair(
            records,
            f"Thông tin tour {name}",
            (
                f"{name} ở {location}, thời lượng {duration}, lưu trú {accommodation}, "
                f"giá {price}, đánh giá {rating}."
            ),
            f"tourModel/{doc_id}",
        )
        add_pair(
            records,
            f"Ảnh tour {name} nằm ở đâu?",
            f"Ảnh đầu tiên của tour {name} đang lưu ở: {image or 'đang cập nhật'}.",
            f"tourModel/{doc_id}",
        )

    for item in knowledge_base.get("searchTour", []):
        value = text(item.get("value"))
        count = text(item.get("count"), "0")
        doc_id = text(item.get("_docId"))
        add_pair(
            records,
            f"Từ khóa {value} có phổ biến không?",
            f"Từ khóa {value} đang có chỉ số tìm kiếm {count} trong dữ liệu mẫu.",
            f"searchTour/{doc_id}",
        )

    for video in knowledge_base.get("videos", []):
        caption = text(video.get("caption"))
        username = text(video.get("username"), "người dùng")
        doc_id = text(video.get("_docId"))
        add_pair(
            records,
            f"Video {caption} của ai?",
            f"Video '{caption}' được đăng bởi {username}.",
            f"videos/{doc_id}",
        )

    add_pair(
        records,
        "Làm sao để đặt tour?",
        "Bạn chọn tour, bấm Book Tour, nhập số người, chọn phương thức thanh toán rồi xác nhận đặt tour.",
        "static/booking_flow",
    )
    add_pair(
        records,
        "App có thanh toán bằng gì?",
        "App hỗ trợ QR payOS, chuyển khoản qua payOS và Visa test mode qua Stripe nếu backend đã được cấu hình.",
        "static/payment_flow",
    )
    add_pair(
        records,
        "Tôi xem lịch sử đặt tour ở đâu?",
        "Bạn mở tab History để xem các booking đang chờ, sắp diễn ra, đang diễn ra, đã hoàn thành hoặc đã hủy.",
        "static/history_flow",
    )

    return records


def write_json(path: Path, data: Any):
    path.write_text(
        json.dumps(data, ensure_ascii=False, indent=2),
        encoding="utf-8",
    )


def write_jsonl(path: Path, rows: Iterable[Dict[str, Any]]):
    with path.open("w", encoding="utf-8") as file:
        for row in rows:
            file.write(json.dumps(row, ensure_ascii=False) + "\n")


def main():
    args = parse_args()
    script_dir = Path(__file__).resolve().parent
    output_dir = Path(args.output_dir)
    if not output_dir.is_absolute():
        output_dir = script_dir / output_dir
    output_dir.mkdir(parents=True, exist_ok=True)

    db = init_firestore(args.service_account, args.project_id)

    knowledge_base: Dict[str, List[Dict[str, Any]]] = {}
    for collection in args.collections:
        print(f"[CHATBOT_EXPORT] Reading {collection}")
        knowledge_base[collection] = fetch_collection(db, collection)
        print(
            f"[CHATBOT_EXPORT] Done {collection}: {len(knowledge_base[collection])} docs"
        )

    records = build_training_records(knowledge_base)

    knowledge_path = output_dir / "chatbot_knowledge_base.json"
    training_path = output_dir / "chatbot_training.jsonl"

    write_json(knowledge_path, knowledge_base)
    write_jsonl(training_path, records)

    print(f"[CHATBOT_EXPORT] Wrote {knowledge_path}")
    print(f"[CHATBOT_EXPORT] Wrote {training_path}")
    print(f"[CHATBOT_EXPORT] Training records: {len(records)}")


if __name__ == "__main__":
    main()
