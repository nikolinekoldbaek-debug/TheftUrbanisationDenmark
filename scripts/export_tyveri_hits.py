from pathlib import Path
import csv

ROOT = Path(__file__).resolve().parents[1]
INTERIM = ROOT / "data" / "interim"
OUT = ROOT / "data" / "interim" / "tyveri_text_hits.csv"

rows = []
for txt in ["krim1870.txt", "rets1905.txt"]:
    current_page = None
    for line_no, line in enumerate((INTERIM / txt).read_text(encoding="utf-8").splitlines(), start=1):
        if line.startswith("===== PAGE "):
            try:
                current_page = int(line.split()[2])
            except Exception:
                current_page = None
        if "tyver" in line.lower():
            rows.append({
                "source_text": txt,
                "page": current_page,
                "line": line_no,
                "text": line.strip(),
            })

with OUT.open("w", newline="", encoding="utf-8") as f:
    writer = csv.DictWriter(f, fieldnames=["source_text", "page", "line", "text"])
    writer.writeheader()
    writer.writerows(rows)

print(f"Wrote {len(rows)} Tyveri text hits to {OUT}")
