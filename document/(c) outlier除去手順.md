<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" style="height:64px;margin-right:32px"/>

# outlierの除去手順

```{r}
# ****************************************************************************
# @title: detect_outliers_weighted_manual
# @description: 重み付き外れ値検出関数（手動グループ処理版）
# @param design: svydesignオブジェクト
# @param var_name: 外れ値検出を行う変数名（文字列）
# @param by_vars: グループ化変数名のベクトル
# @return: 外れ値フラグが追加されたデータフレーム
# ****************************************************************************

detect_outliers_weighted_manual <- function(design, var_name, by_vars) {

# データと重みを取得

df_data <- model.frame(design) weights_vec <- weights(design, "sampling") df_data$survey_weight <- weights_vec

# ★★★ 行番号を保持 ★★★

df_data$original_rowid <- 1:nrow(df_data)

# 外れ値フラグ列を初期化

outlier_col <- paste0(var_name, "_is_outlier") df_data[[outlier_col]] <- FALSE

# グループごとに処理

groups <- df_data %>% select(all_of(by_vars)) %>% distinct()

for(i in 1:nrow(groups)) { # グループフィルタ作成 group_filter <- rep(TRUE, nrow(df_data)) for(var in by_vars) { group_filter <- group_filter & (df_data[[var]] == groups[[var]],[i]) }



# グループデータ抽出

group_data <- df_data[group_filter, ] group_values <- group_data[[var_name]] group_weights <- group_data$survey_weight

# 有効データのみ

valid_idx <- !is.na(group_values) if(sum(valid_idx) \< 5) next # データ不足はスキップ

valid_values <- group_values[valid_idx] valid_weights <- group_weights[valid_idx]

# 重み付き分位数計算

tryCatch({ q25 <- wtd.quantile(valid_values, weights = valid_weights, probs = 0.25) q75 <- wtd.quantile(valid_values, weights = valid_weights, probs = 0.75)

IQR <- q75 - q25 lower_fence <- q25 - 1.5 \* IQR upper_fence <- q75 + 1.5 \* IQR

# 外れ値フラグ設定 outlier_idx <- which(group_filter & !is.na(df_data[[var_name]]) & (df_data[[var_name]] \< lower_fence \| df_data[[var_name]] \> upper_fence))

if(length(outlier_idx) \> 0) { df_data[[outlier_col]],[outlier_idx] <- TRUE }

}, error = function(e) { cat("Error processing group for", var_name, ":", e$message, "\n") }) }


# ★★★ 元の行順序で返す ★★★

df_data <- df_data[order(df_data$original_rowid), ] return(df_data[, c(var_name, outlier_col)]) # 必要な列のみ返す }

# ------関数ここまで----------------------------------------------------------

by_vars <- c("region", "inc_quintile")

# 外れ値検出と統計サマリー用

outlier_summary_list <- list()

for(var in myVar) { cat("外れ値検出中:", var, "\n")

# 外れ値検出

result <- detect_outliers_weighted_manual(enaho_design, var, by_vars) outlier_col <- paste0(var, "_is_outlier")

# 統計計算

n_outliers <- sum(result[[outlier_col]], na.rm = TRUE) n_total <- sum(!is.na(model.frame(enaho_design)[[var]])) outlier_rate <- ifelse(n_total \> 0, (n_outliers / n_total) \* 100, 0)

outlier_summary_list[[var]] <- data.frame( variable = var, total_obs = n_total, outliers = n_outliers, outlier_rate = outlier_rate )

# ★★★ 最もシンプルな方法：$variables を直接書き換え ★★★

enaho_design$variables[[var]],[result[[outlier_col]]] <- NA

cat(" 外れ値数:", n_outliers, "/", n_total, "(", round(outlier_rate, 2), "%)\n") }

# 外れ値統計サマリー

outlier_summary <- bind_rows(outlier_summary_list) print(outlier_summary)

# 外れ値除去前後の比較（元の設計オブジェクトと比較したい場合は事前にコピーが必要）

# ※ 上記ループで enaho_design を直接更新しているため、

# 比較用に元のデータが必要なら enaho_design_original <- enaho_design でバックアップしておく

cat("\n外れ値除去完了！enaho_design が更新されました。\n")

# この enaho_design を使って tbl_svysummary を実行

p <- summary_stats_gt( design = enaho_design, by_var = by_var, analysis_vars = analysis_vars )
```

コードを **step by step** で解説します：

## **Phase 1: 関数定義 `detect_outliers_weighted_manual`**

```{r}
detect_outliers_weighted_manual <- function(design, var_name, by_vars)
```

### Step 1: データ準備

```{r}
df_data <- model.frame(design)               # ← survey designからデータフレーム抽出
weights_vec <- weights(design, "sampling")   # ← サンプリング重みを抽出
df_data$survey_weight <- weights_vec         # ← 重みを新列として追加
df_data$original_rowid <- 1:nrow(df_data)   # ← 元の行番号を保持
```

### Step 2: 外れ値フラグ初期化

```{r}
outlier_col <- paste0(var_name, "_is_outlier")  # ← 例："staple_legume_is_outlier"
df_data[[outlier_col]] <- FALSE                 # ← 全行をFALSEで初期化
```

### Step 3: グループ抽出とループ処理

```{r}
groups <- df_data %>% select(all_of(by_vars)) %>% distinct()
# ← by_vars=c("region","inc_quintile")の全ユニーク組み合わせを取得

for(i in 1:nrow(groups)) {
  # 各グループについて外れ値検出実行
}
```

### Step 4: グループごとの外れ値検出

```{r}
# 現在のグループに属する行をフィルタ
group_filter <- rep(TRUE, nrow(df_data))
for(var in by_vars) {
  group_filter <- group_filter & (df_data[[var]] == groups[[var]],[i])
}

# 重み付き四分位数・IQR計算
valid_values <- group_values[valid_idx]
valid_weights <- group_weights[valid_idx]
q25 <- wtd.quantile(valid_values, weights = valid_weights, probs = 0.25)
q75 <- wtd.quantile(valid_values, weights = valid_weights, probs = 0.75)
IQR <- q75 - q25
lower_fence <- q25 - 1.5 * IQR
upper_fence <- q75 + 1.5 * IQR

# 外れ値インデックスを特定してフラグ設定
outlier_idx <- which(group_filter & !is.na(df_data[[var_name]]) & 
    (df_data[[var_name]] < lower_fence | df_data[[var_name]] > upper_fence))
df_data[[outlier_col]],[outlier_idx] <- TRUE
```

### Step 5: 結果返却

```{r}
df_data <- df_data[order(df_data$original_rowid), ]   # ← 元の行順序に戻す
return(df_data[, c(var_name, outlier_col)])          # ← 必要な列のみ返す
```

------------------------------------------------------------------------

## **Phase 2: メインループ処理**

### Step 6: 各変数について外れ値検出

```{r}
for(var in myVar) {  # ← myVar = c("staple_legume", "vegetable", "fruit", ...)
  
  # 外れ値検出実行
  result <- detect_outliers_weighted_manual(enaho_design, var, by_vars)
  # ← 戻り値：data.frame with 2 columns (var, var_is_outlier)
  
  outlier_col <- paste0(var, "_is_outlier")
  
  # 統計計算
  n_outliers <- sum(result[[outlier_col]], na.rm = TRUE)     # ← 外れ値数
  n_total <- sum(!is.na(model.frame(enaho_design)[[var]]))   # ← 総観測数
  outlier_rate <- ifelse(n_total > 0, (n_outliers / n_total) * 100, 0)
  
  # 統計サマリーを保存
  outlier_summary_list[[var]] <- data.frame(...)
  
  # ★★★ 重要：survey designオブジェクトの変数を直接書き換え ★★★
  enaho_design$variables[[var]],[result[[outlier_col]]] <- NA
  
  cat("外れ値数:", n_outliers, "/", n_total, "(", round(outlier_rate, 2), "%)\n")
}
```

### Step 7: 最終処理と出力

```{r}
outlier_summary <- bind_rows(outlier_summary_list)  # ← 統計サマリー作成
p <- summary_stats_gt(design = enaho_design, ...)  # ← 更新済みdesignで集計表作成
```

------------------------------------------------------------------------

## **`staple_legume` が変化しない理由（推定）**

**問題の核心：**

```{r}
# myVar に "staple_legume" が含まれているが...
myVar <- c("staple_legume", "vegetable", "fruit", "dairy", "ASF", "oilfat")

# もし元データに "staple", "legume" も含まれていて、
# かつ staple_legume = staple + legume を get_food_consumption_capita() で計算済みなら...
```

**推定される問題：**

1.  `enaho_design$variables` には既に **計算済みの `staple_legume`** が入っている
2.  しかし `staple_legume` の外れ値検出・NA置換は **元の `staple`, `legume` とは独立** に実行される
3.  `staple_legume` 自体には外れ値がほとんどない（合成により値が平滑化されている）
4.  一方で `staple`, `legume` 個別には外れ値があっても，`staple_legume` には反映されない

**確認すべきこと：**

```{r}
# 1. staple_legume の外れ値数を確認
table(result[["staple_legume_is_outlier"]])

# 2. staple, legume の個別外れ値と staple_legume への影響を確認
cat("staple外れ値数:", sum(detect_outliers_weighted_manual(enaho_design, "staple", by_vars)[["staple_is_outlier"]]))
cat("legume外れ値数:", sum(detect_outliers_weighted_manual(enaho_design, "legume", by_vars)[["legume_is_outlier"]]))

# 3. staple_legume の再計算が必要かチェック
head(enaho_design$variables[, c("staple", "legume", "staple_legume")])
```

[^(c-outlier除去手順-1],[^(c-outlier除去手順-2],[^(c-outlier除去手順-3],[^(c-outlier除去手順-4],[^(c-outlier除去手順-5],[^(c-outlier除去手順-6],[^(c-outlier除去手順-7],[^(c-outlier除去手順-8],[^(c-outlier除去手順-9],[^(c-outlier除去手順-10],[^(c-outlier除去手順-11],[^(c-outlier除去手順-12],[^(c-outlier除去手順-13],[^(c-outlier除去手順-14],[^(c-outlier除去手順-15],[^(c-outlier除去手順-16]

[^(c-outlier除去手順-1]: [<https://r-survey.r-forge.r-project.org/survey/html/update.survey.design.html>]{style="display:none"}

[^(c-outlier除去手順-2]: <https://inzight.nz/docs/survey-specification.html>

[^(c-outlier除去手順-3]: <https://www.epirhandbook.com/en/new_pages/survey_analysis.html>

[^(c-outlier除去手順-4]: <https://www.bookdown.org/rwnahhas/RMPH/survey-design.html>

[^(c-outlier除去手順-5]: <https://tidy-survey-r.github.io/tidy-survey-short-course/Presentation/Slides-day-3.html>

[^(c-outlier除去手順-6]: <https://isi-iass.org/home/wp-content/uploads/Survey_Statistician_2025_January_N91_06.pdf>

[^(c-outlier除去手順-7]: <https://ukdataserviceopen.github.io/Introduction_to_the_BSA/infer_w_survey_design_usingR.html>

[^(c-outlier除去手順-8]: [https://www.rdocumentation.org/link/update.survey.design?package=survey\\&version=2.8-1](https://www.rdocumentation.org/link/update.survey.design?package=survey&version=2.8-1){.uri}

[^(c-outlier除去手順-9]: <https://stackoverflow.com/questions/70436793/dynamic-variable-names-in-svydesign-from-survey-package>

[^(c-outlier除去手順-10]: <https://cran.r-project.org/web/packages/survey/survey.pdf>

[^(c-outlier除去手順-11]: <https://stackoverflow.com/questions/54803670/using-mutate-and-the-srvyr-package-for-the-calculation-of-percentages-in-a-sur>

[^(c-outlier除去手順-12]: <https://www.rdocumentation.org/packages/survey/versions/4.4-8/topics/svydesign>

[^(c-outlier除去手順-13]: <https://zacharylhertz.github.io/posts/2021/06/survey-package/>

[^(c-outlier除去手順-14]: <http://r-survey.r-forge.r-project.org/pkgdown/docs/reference/update.survey.design.html>

[^(c-outlier除去手順-15]: <https://jamescheshire.github.io/learningR/complex-survey-design.html>

[^(c-outlier除去手順-16]: <https://www.rdocumentation.org/packages/survey/versions/1.1/topics/update.survey.design>

::: {align="center"}
⁂
:::
