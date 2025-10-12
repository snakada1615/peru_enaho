# ENAHOデータの複雑サンプリング設計に対応した統計分析手順

## 1. 概要と問題提起

ペルーの消費統計（ENAHO）はマルチステージクラスターサンプリングを採用しているため、単純な統計関数では正しい母集団推定ができません。本文書では、`survey`パッケージを用いた適切な分析手順を整理します。

## 2. サンプルサイズと分析精度の検討

### 2.1 データ構造

-   全体サンプル数：22,204件
-   県（department）数：25県
-   県別サンプル数：最小606件～最大2,726件

### 2.2 所得階層区分の選択

#### 10区分（Decile）の場合

-   1セル当たり平均44サンプル（最小県で30サンプル）
-   統計的推定には不安定

#### 5区分（Quintile）の場合【推奨】

-   1セル当たり平均89サンプル（最小県で61サンプル）
-   統計的に信頼できる推定が可能
-   サブグループ分析の最小基準（50-100サンプル）を満たす

### 2.3 推奨分析戦略

``` r
# 全国レベル：10区分で詳細分析
# 県レベル：5区分で安定した推定
```

## 3. surveyパッケージによる実装

### 3.1 基本設定

``` r
library(survey)
library(ggplot2)
library(dplyr)
library(tidyr)

# 孤立PSU対策
options(survey.lonely.psu = "adjust")

# 変数定義
myVar <- c("staple", "vegetable", "fruit", "legume", "ASF", "dairy", "oilfat", "other")
```

### 3.2 サーベイデザインの作成

#### 正しい書き方

``` r
enaho_design <- svydesign(
  id = ~ CONGLOME,
  strata = ~ ESTRATO,
  weights = ~ FACTOR07,  # 実際の列名を直接指定
  data = df_foodgrp_consumption_capita,
  nest = TRUE
)
```

#### よくある間違い

``` r
# ❌ 文字列変数をそのまま使用
myfactor <- "FACTOR07"
weights = ~ myfactor  # 「myfactor」という列名を探してしまう

# ✅ 修正方法
weight_formula <- as.formula(paste("~", myfactor))
weights = weight_formula
```

### 3.3 所得階層の作成

#### 5分位点の計算

``` r
income_q <- svyquantile(
  ~ INGMO2HD,  # または income_net（データに応じて）
  design = enaho_design,
  quantiles = seq(0.2, 0.8, by = 0.2),  # 0.2, 0.4, 0.6, 0.8
  na.rm = TRUE,
  ci = FALSE
)
```

#### 分位点の値抽出

##### 新しいsurveyパッケージ（v4.1以降）

``` r
# newsvyquantile構造から抽出
quantile_values <- income_q$income_net[1, ]  # 推奨方法

# 代替方法
quantile_values <- as.vector(income_q$income_net)
quantile_values <- c(income_q$income_net)
quantile_values <- drop(income_q$income_net)
```

##### 従来のcoef()関数は新構造では使用不可

``` r
# ❌ エラーが発生
quantile_values <- coef(income_q)  # 'list' object cannot be coerced to type 'double'
```

#### 所得階層ラベルの付与

``` r
# 境界ベクトル作成（6個の境界で5つの区間）
breaks <- c(-Inf, quantile_values, Inf)

# 5分位区分作成
df_clean$inc_quintile <- cut(
  df_clean$INGMO2HD,
  breaks = breaks,
  labels = paste0("Q", 1:5),  # 5個のラベル（区間数と一致）
  include.lowest = TRUE
)

# デザインオブジェクト更新
enaho_design <- update(enaho_design, inc_quintile = df_clean$inc_quintile)
```

## 4. 要約統計の算出

### 4.1 従来手法からの置き換え

| 従来の関数   | survey対応関数               | 備考                   |
|--------------|------------------------------|------------------------|
| `summary()`  | `svymean()`, `svyquantile()` | 複数関数の組み合わせ   |
| `describe()` | 個別算出                     | 歪度・尖度は要別途実装 |
| `mean()`     | `svymean()`                  | 加重平均               |
| `quantile()` | `svyquantile()`              | 加重分位点             |
| `var()`      | `svyvar()`                   | 加重分散               |

### 4.2 実装例

#### 平均と信頼区間

``` r
# 食品群別平均
food_means <- svymean(
  as.formula(paste("~", paste(myVar, collapse = "+"))),
  design = enaho_design,
  na.rm = TRUE
)

# 95%信頼区間
confint(food_means)
```

#### 所得階層別集計

``` r
# 階層別平均
by_income <- svyby(
  as.formula(paste("~", paste(myVar, collapse = "+"))),
  ~ inc_quintile,
  design = enaho_design,
  svymean,
  na.rm = TRUE,
  vartype = c("se", "ci")
)
```

#### 中央値・分位点

``` r
# 食品群別中央値
food_medians <- svyquantile(
  as.formula(paste("~", paste(myVar, collapse = "+"))),
  design = enaho_design,
  quantiles = 0.5,
  ci = TRUE,
  na.rm = TRUE
)
```

## 5. 可視化の実装

### 5.1 重み付き可視化の原則

-   素のggplotは複雑サンプル設計を考慮しない
-   「survey関数で事前集計→ggplot」の手順を推奨

### 5.2 重み付きヒストグラム

``` r
# データのlong化（ウェイト列を含む）
df_long <- df_clean %>%
  select(all_of(myVar), FACTOR07) %>%
  pivot_longer(cols = all_of(myVar), 
               names_to = "variable", 
               values_to = "value") %>%
  filter(!is.na(value), !is.na(FACTOR07))

# 加重ヒストグラム
ggplot(df_long, aes(x = value, weight = FACTOR07)) +
  geom_histogram(aes(y = after_stat(density)), 
                 bins = 30, fill = "lightgray", alpha = 0.8) +
  facet_wrap(~ variable, scales = "free", ncol = 3) +
  theme_minimal()
```

### 5.3 箱ひげ図の代替（分位点プロット）

``` r
# 変数ごとの分位点を事前集計
qd <- lapply(myVar, function(v){
  qq <- svyquantile(as.formula(paste0("~", v)), 
                    enaho_design, 
                    c(0.25, 0.5, 0.75), 
                    ci = FALSE, na.rm = TRUE)
  data.frame(variable = v, 
             Q1 = qq[[v]][1], 
             median = qq[[v]][2], 
             Q3 = qq[[v]][3])
})
qd <- bind_rows(qd)

# 疑似箱ひげ図
ggplot(qd, aes(x = variable)) +
  geom_linerange(aes(ymin = Q1, ymax = Q3), 
                 size = 8, color = "lightblue", alpha = 0.7) +
  geom_point(aes(y = median), color = "navy", size = 2) +
  coord_flip() +
  theme_minimal()
```

### 5.4 所得階層別比較

``` r
# 所得階層別の結果をlong化
by_long <- by_income %>%
  tidyr::pivot_longer(-inc_quintile, 
                      names_to = "variable", 
                      values_to = "mean") %>%
  # 信頼区間の情報も結合（列名は環境により異なる）
  left_join(confidence_interval_data, by = c("inc_quintile", "variable"))

# エラーバー付き棒グラフ
ggplot(by_long, aes(x = inc_quintile, y = mean, color = variable)) +
  geom_point(position = position_dodge(width = 0.5)) +
  geom_errorbar(aes(ymin = ci_l, ymax = ci_u),
                position = position_dodge(width = 0.5), 
                width = 0.2) +
  theme_minimal()
```

## 6. よくあるエラーと対処法

### 6.1 ウェイト変数エラー

```         
Error in 1/as.matrix(weights) : non-numeric argument to binary operator
```

**原因**: 文字列変数をweights引数に渡している **対処**: 実際の列名を直接指定 `weights = ~ FACTOR07`

### 6.2 分位点抽出エラー

```         
Error: 'list' object cannot be coerced to type 'double'
```

**原因**: 新しいsvyquantile構造に対して古い抽出方法を使用 **対処**: `quantile_values <- income_q$variable_name[1, ]`

### 6.3 cut()関数エラー

```         
Error: number of intervals and length of 'labels' differ
```

**原因**: breaks数とlabels数の不一致 **対処**: n個のbreaksに対してn-1個のlabelsを指定

### 6.4 Quartoキャッシュ問題

**症状**: 修正後もエラーメッセージが残る **対処**: 古い出力をクリアして再実行

## 7. 完全なワークフロー例

``` r
# ライブラリ読み込み
library(survey)
library(ggplot2)
library(dplyr)
library(tidyr)

# 設定
options(survey.lonely.psu = "adjust")
myVar <- c("staple", "vegetable", "fruit", "legume", "ASF", "dairy", "oilfat", "other")

# データクリーニング
df_clean <- df_foodgrp_consumption_capita[
  !is.na(df_foodgrp_consumption_capita$FACTOR07) & 
  !is.na(df_foodgrp_consumption_capita$INGMO2HD), 
]

# サーベイデザイン
enaho_design <- svydesign(
  id = ~ CONGLOME,
  strata = ~ ESTRATO,
  weights = ~ FACTOR07,
  data = df_clean,
  nest = TRUE
)

# 所得5分位作成
income_q <- svyquantile(~ INGMO2HD, enaho_design, 
                        seq(0.2, 0.8, by = 0.2), na.rm = TRUE, ci = FALSE)
quantile_values <- income_q$INGMO2HD[1, ]
breaks <- c(-Inf, quantile_values, Inf)
df_clean$inc_quintile <- cut(df_clean$INGMO2HD, breaks, 
                             labels = paste0("Q", 1:5), include.lowest = TRUE)
enaho_design <- update(enaho_design, inc_quintile = df_clean$inc_quintile)

# 記述統計
food_means <- svymean(~ staple + vegetable + fruit + legume + ASF + dairy + oilfat + other,
                      enaho_design, na.rm = TRUE)
by_income <- svyby(~ staple + vegetable + fruit + legume + ASF + dairy + oilfat + other,
                   ~ inc_quintile, enaho_design, svymean, na.rm = TRUE)

# 結果確認
print(food_means)
print(by_income)
```

## 8. まとめ

-   ENAHOの複雑サンプリング設計には必ずsurveyパッケージを使用
-   所得階層は5分位（Quintile）を推奨（統計的安定性確保）
-   新しいsurveyパッケージでは分位点抽出方法が変更されている
-   可視化は「事前集計→ggplot」の手順で実装
-   Quartoでは古い出力をクリアしてから再実行
