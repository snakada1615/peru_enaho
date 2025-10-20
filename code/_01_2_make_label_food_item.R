
rm(list = ls(all = TRUE))

# libraries needed
library(tidyverse)  # most variable creation here uses tidyverse
library(openxlsx) # for reading/writing Excel files

# 対象とする年のリスト
yearlist <- c("2007", "2008", "2009", "2010", "2011",
              "2012", "2013", "2014", "2015", "2016")

# DHSデータのルートフォルダを指定
gdrive_dir <- "/Users/snakada/Library/CloudStorage/GoogleDrive-snakada@g.ecc.u-tokyo.ac.jp/マイドライブ/Peru_work/peru_enaho"

# 各種の関数セット読み込み
source("myTools.R")  # プロジェクトルートから読み込む
enaho_files_list <- readRDS(file = file.path(gdrive_dir, "output", "enaho_files_list.rds"))

res <- NULL

for (year_current in yearlist) {
  cat("Processing", year_current, "...\n")
  
  # データ保存先フォルダ
  save_folder <- file.path(gdrive_dir, "output", year_current)
  
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
      label_text = lab_names,
      year = year_current
    ) %>%
      mutate(code_num = suppressWarnings(as.numeric(code_raw)))
  } else {
    map_attr <- tibble(code_raw = character(), label_text = character(), year = character())
  }
  
  res <- bind_rows(res, map_attr)
  
  # write.xlsx(map_attr,
  #   file = file.path(save_folder, paste0("label_map_food_item_", year_current, ".xlsx")),
  #            sheetName = "label_map_food_item",
  #            overwrite = TRUE)
  # cat("  Saved label map for year", year_current, "\n")  
}

# 全年分をまとめて保存
write.xlsx(res,
  file = file.path(gdrive_dir, "output", "itemlist_expenditure.xlsx"),
           sheetName = "foodlist",
           overwrite = TRUE)
cat("Saved combined label map for all years.\n")
