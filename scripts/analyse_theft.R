dir.create("figures", showWarnings = FALSE)

read_csv_base <- function(path) {
  read.csv(path, stringsAsFactors = FALSE, na.strings = c("", "NA"))
}

theft_1870 <- read_csv_base("data/processed/theft_1866_1870_by_region_category.csv")
theft_1905 <- read_csv_base("data/processed/theft_1901_1905_harmonised.csv")
urban <- read_csv_base("data/processed/urbanisation_reference.csv")
property_1905 <- read_csv_base("data/processed/property_crime_reference_1901_1905.csv")

urban_1870 <- aggregate(convictions_5yr ~ urban_status, theft_1870, sum)
urban_1870$annual_average <- urban_1870$convictions_5yr / 5
urban_1870$share_pct <- round(urban_1870$convictions_5yr / sum(urban_1870$convictions_5yr) * 100, 1)

regions_1870 <- aggregate(convictions_5yr ~ region_clean + urban_status, theft_1870, sum)
regions_1870 <- regions_1870[order(regions_1870$convictions_5yr, decreasing = TRUE), ]

merge_1870 <- aggregate(convictions_5yr ~ merge_group, theft_1870, sum)
core_1870 <- sum(theft_1870$convictions_5yr[theft_1870$merge_group == "core_theft"])
all_tyveri_1870 <- sum(theft_1870$convictions_5yr)
core_1905_est <- sum(theft_1905$total_5yr_estimated[theft_1905$merge_group == "core_theft"], na.rm = TRUE)

comparison <- data.frame(
  period = c("1866-1870", "1901-1905"),
  theft_measure = c("Core theft convictions, exact 5-year count", "Core theft convictions, estimated from stated annual averages"),
  theft_5yr = c(core_1870, core_1905_est),
  annual_average = c(core_1870 / 5, core_1905_est / 5),
  urban_population_share_pct = c(25, 40)
)
comparison$index_1870_100 <- round(comparison$theft_5yr / comparison$theft_5yr[1] * 100, 1)

write.csv(urban_1870, "data/processed/summary_1870_urban_rural_theft.csv", row.names = FALSE)
write.csv(regions_1870, "data/processed/summary_1870_region_theft.csv", row.names = FALSE)
write.csv(comparison, "data/processed/summary_period_comparison.csv", row.names = FALSE)

png("figures/theft_1870_urban_rural.png", width = 1200, height = 850, res = 150)
par(mar = c(5, 5, 4, 1))
cols <- c("Urban" = "#2f6f73", "Rural" = "#c75b39")
barplot(
  setNames(urban_1870$convictions_5yr, urban_1870$urban_status),
  col = cols[urban_1870$urban_status],
  ylim = c(0, max(urban_1870$convictions_5yr) * 1.25),
  ylab = "Theft-related convictions, 5-year total",
  main = "Theft-related convictions by urban/rural jurisdiction, 1866-1870"
)
text(
  x = seq_along(urban_1870$convictions_5yr) * 1.2 - 0.5,
  y = urban_1870$convictions_5yr,
  labels = paste0(urban_1870$convictions_5yr, "\n", urban_1870$share_pct, "%"),
  pos = 3
)
dev.off()

png("figures/theft_by_region_1870.png", width = 1400, height = 900, res = 150)
par(mar = c(8, 5, 4, 1))
barplot(
  setNames(regions_1870$convictions_5yr, regions_1870$region_clean),
  col = cols[regions_1870$urban_status],
  las = 2,
  ylab = "Theft-related convictions, 5-year total",
  main = "Where theft convictions were recorded, 1866-1870"
)
legend("topright", fill = cols, legend = names(cols), bty = "n")
dev.off()

png("figures/theft_and_urbanisation_comparison.png", width = 1400, height = 900, res = 150)
par(mar = c(5, 5, 4, 5))
plot(
  comparison$urban_population_share_pct,
  comparison$theft_5yr,
  type = "b",
  pch = 16,
  lwd = 3,
  col = "#2f6f73",
  xaxt = "n",
  xlim = c(23, 42),
  ylim = c(8600, 10450),
  xlab = "Urban population share",
  ylab = "Core theft convictions, 5-year total",
  main = "Core theft convictions rose while Denmark became more urban"
)
axis(1, at = comparison$urban_population_share_pct, labels = paste0(comparison$urban_population_share_pct, "%"))
text(
  comparison$urban_population_share_pct,
  comparison$theft_5yr,
  labels = paste0(comparison$period, "\n", comparison$theft_5yr),
  pos = c(4, 2),
  offset = 0.7
)
dev.off()

html <- paste0(
  "<!doctype html><html><head><meta charset='utf-8'><title>Theft and Urbanisation in Denmark</title>",
  "<style>body{font-family:-apple-system,BlinkMacSystemFont,'Segoe UI',sans-serif;max-width:980px;margin:40px auto;padding:0 24px;line-height:1.55;color:#1f2933} img{max-width:100%;border:1px solid #ddd} code,pre{background:#f3f4f6;border-radius:6px} pre{padding:12px;overflow:auto} table{border-collapse:collapse}td,th{border-bottom:1px solid #ddd;padding:6px 10px;text-align:left}</style></head><body>",
  "<h1>Did theft increase as Denmark became more urbanised during industrialisation?</h1>",
  "<p><strong>Hypothesis:</strong> theft increased as Denmark became more urbanised.</p>",
  "<p>The analysis uses two Danmarks Statistik publications: <em>Kriminalstatistik 1866-1870</em> and <em>Retsplejen 1901-1905</em>. I searched for theft categories containing <code>Tyveri</code>, cleaned spelling/OCR variants, and merged comparable theft categories.</p>",
  "<h2>Final visualisation</h2>",
  "<p><img src='figures/theft_and_urbanisation_comparison.png' alt='Theft and urbanisation comparison'></p>",
  "<h2>Urban/rural detail for 1866-1870</h2>",
  "<p><img src='figures/theft_1870_urban_rural.png' alt='Urban rural theft 1870'></p>",
  "<p><img src='figures/theft_by_region_1870.png' alt='Regional theft 1870'></p>",
  "<h2>Main finding</h2>",
  "<p>Core theft convictions increased from ", core_1870, " in 1866-1870 to about ", core_1905_est, " in 1901-1905. Over roughly the same historical shift, the urban share of Denmark's population rose from 25% in 1870 to 40% in 1906. This supports the hypothesis in a cautious way: recorded theft rose while Denmark became more urban, but the data do not prove urbanisation caused the rise.</p>",
  "<h2>Limits</h2>",
  "<p>The 1901-1905 source gives some theft counts as stated annual averages and changes the legal categories. The 1866-1870 source gives better urban/rural detail for theft itself. Therefore, the comparison is harmonised, not perfectly identical. The data measure convictions and legal reporting practices, not all thefts actually committed.</p>",
  "</body></html>"
)
writeLines(html, "TheftUrbanisation_report.html")

print(urban_1870)
print(comparison)
