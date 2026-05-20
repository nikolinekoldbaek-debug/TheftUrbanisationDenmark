# Theft and urbanisation in Denmark

Research question: **Did theft increase as Denmark became more urbanised during industrialisation?**

Hypothesis: theft increased as Denmark became more urbanised.

## Sources

- Danmarks Statistik, criminal statistics 1866-1870: `data/raw/krim1870.pdf`
- Danmarks Statistik, justice statistics 1901-1905: `data/raw/rets1905.pdf`

## Main files

- `TheftUrbanisation_report.Rmd`: R Markdown report.
- `TheftUrbanisation_report.html`: rendered preview made with local fallback tools.
- `data/processed/theft_1866_1870_by_region_category.csv`: cleaned 1866-1870 theft data.
- `data/processed/theft_1901_1905_harmonised.csv`: harmonised 1901-1905 theft data.
- `data/interim/tyveri_text_hits.csv`: all text hits containing `Tyveri`.
- `openrefine/facet_cleaning_log.csv`: cleaning decisions and text-facet corrections.
- `openrefine/openrefine_operations.json`: OpenRefine-style operation notes.
- `figures/theft_and_urbanisation_comparison.png`: final visualisation.

## Important limitation

OpenRefine is not installed in the local Codex environment, so the cleaning has been documented in OpenRefine-compatible logs rather than performed through the OpenRefine GUI. The cleaned data keeps original labels, cleaned labels, and merge groups so the process can be checked and repeated.

The 1901-1905 source changes the legal categories. The comparison therefore uses a harmonised `core_theft` measure and notes where exact counts were not recoverable from the PDF extraction.
