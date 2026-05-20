from pathlib import Path

from pypdf import PdfReader

ROOT = Path(__file__).resolve().parents[1]
RAW = ROOT / "data" / "raw"
OUT = ROOT / "data" / "interim"
OUT.mkdir(parents=True, exist_ok=True)

for pdf_path in sorted(RAW.glob("*.pdf")):
    reader = PdfReader(str(pdf_path))
    lines = []
    for i, page in enumerate(reader.pages, start=1):
        text = page.extract_text() or ""
        lines.append(f"\n\n===== PAGE {i} =====\n\n{text}")
    (OUT / f"{pdf_path.stem}.txt").write_text("\n".join(lines), encoding="utf-8")
    print(f"{pdf_path.name}: {len(reader.pages)} pages")
