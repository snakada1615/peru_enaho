library(dplyr)
library(haven)
library(readr)
library(glue)

#' *****************************************************************************
#' P601A の food code unmatched を年ごとに抽出・保存する
#' *****************************************************************************

# ---- ユーザーが設定する変数 ----
yearlist <- as.character(2007:2016)    # 例
# df_food_grp <- ...                     # 既に読み込み済み。df_food_grp$code_food は numeric
# open_enaho_file(year, "mod7") 関数が定義済みであること

out_root <- file.path(getwd(), "P601A_unmatched_by_year")  # 出力先フォルダ（必要に応じ変更）
if (!dir.exists(out_root)) dir.create(out_root, recursive = TRUE)

# 既存の food codes（numeric）
existing_codes <- sort(unique(df_food_grp$code_food))

# 年ごとに処理
all_unmatched_list <- list()

for (year_current in yearlist) {
  cat("Processing", year_current, "...\n")
  # 読み込み
  df_mod7 <- open_enaho_file(year_current, "mod7")
  if (is.null(df_mod7) || !"P601A" %in% names(df_mod7)) {
    warning(glue("Year {year_current}: df_mod7 missing or P601A not present. Skipping."))
    next
  }
  
  # 1) 元ラベル属性からコード→説明ラベルのマップを作る（あれば）
  p <- df_mod7$P601A
  lab_attr <- attr(p, "labels")
  
  if (!is.null(lab_attr)) {
    # lab_attr: named vector where names = descriptive labels, values = code strings or numbers
    # 正規化して data.frame にする
    lab_values <- as.character(unname(lab_attr))
    lab_names  <- names(lab_attr)
    map_attr <- tibble(
      code_raw = trimws(lab_values),
      label_text = lab_names
    ) %>%
      mutate(code_num = suppressWarnings(as.numeric(code_raw)))
  } else {
    map_attr <- tibble(code_raw = character(), label_text = character(), code_num = numeric())
  }
  
  # 2) 実際に出現しているコード（raw と numeric）と出現頻度を作る
  df_codes <- df_mod7 %>%
    mutate(
      code_raw = trimws(haven::zap_labels(P601A)),   # e.g. "0100" or " 100"
      code_num = suppressWarnings(as.numeric(code_raw))
    ) %>%
    group_by(code_num, code_raw) %>%
    summarise(freq = n(), .groups = "drop") %>%
    arrange(desc(freq))
  
  # 3) ラベルが map_attr にあれば結合して説明ラベルを付与。なければ NA のまま
  df_codes <- df_codes %>%
    left_join(map_attr %>% distinct(code_num, label_text), by = "code_num")
  
  # 4) unmatched を抽出（df_food_grp に code_num がない）
  unmatched_tbl <- df_codes %>%
    filter(is.na(code_num) | !(code_num %in% existing_codes)) %>%
    # 注: code_num が NA の場合も出力（何らかの非数値コードがあるため）
    arrange(desc(freq))
  
  # 5) 保存（年ごと）
  out_file <- file.path(out_root, paste0("P601A_unmatched_", year_current, ".csv"))
  readr::write_csv(unmatched_tbl, out_file)
  cat("  -> saved:", out_file, " (", nrow(unmatched_tbl), "rows )\n")
  
  # collect for master
  if (nrow(unmatched_tbl) > 0) {
    unmatched_with_year <- unmatched_tbl %>%
      mutate(year = year_current) %>%
      select(year, code_num, code_raw, label_text, freq)
    all_unmatched_list[[year_current]] <- unmatched_with_year
  }
}

# 6) 全年まとめを保存
if (length(all_unmatched_list) > 0) {
  master_unmatched <- bind_rows(all_unmatched_list) %>%
    arrange(year, desc(freq))
  master_file <- file.path(out_root, "P601A_unmatched_all_years.csv")
  readr::write_csv(master_unmatched, master_file)
  cat("Master unmatched saved:", master_file, "\n")
} else {
  cat("No unmatched codes found in any year (or nothing collected).\n")
}