<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" style="height:64px;margin-right:32px"/>

## 対数変換後のスコア評価について

食品消費量を対数変換した場合、**スコア評価も対数変換された値で行うべきです**。以下、その理由と具体的な実装方法を説明します。

### 対数スケールでスコア評価すべき理由

**1. 比率の一貫性**

対数変換の主な利点は、乗法的な関係を加法的な関係に変換することです。元のスケールで「推奨値の90-110%」という基準は、対数スケールでは以下のように表現されます:

$$
\log(0.9 \times \text{FBDG}) \text{ から } \log(1.1 \times \text{FBDG})
$$

これは次のように書き換えられます:

$$
\log(\text{FBDG}) + \log(0.9) \text{ から } \log(\text{FBDG}) + \log(1.1)
$$

**2. ばらつきへの対応**

消費量のばらつきが非常に大きい場合、対数変換することで分布が正規分布に近づきます。この変換後の分布に対して評価することで、外れ値の影響を抑え、より安定したスコアリングが可能になります。

**3. 食品群間の比較可能性**

異なる食品群で消費量の単位やスケールが大きく異なる場合、対数変換により食品群間の比較可能性が向上します。

### 実装方法

以下の2つのアプローチがあります:

#### アプローチ1: 対数変換後にスコア評価

```{r}
add_food_score_log <- function(df, myVar, fbdg_dat){
  # 対数変換された推奨値を計算
  log_fbdg <- lapply(fbdg_dat, log)
  
  df <- df %>%
    mutate(across(all_of(myVar),
      ~ case_when(
          . >= log(0.9) + log_fbdg[[cur_column()]] & 
          . < log(1.1) + log_fbdg[[cur_column()]] ~ 1,
          . >= log(1.1) + log_fbdg[[cur_column()]] ~ 2,
          . < log(0.9) + log_fbdg[[cur_column()]] ~ 3,
          !is.na(.) ~ NA_real_,
          TRUE ~ NA_real_
        ),
      .names = "{.col}_score"
    ))
  
  return(df)
}
```

#### アプローチ2: より明示的な記述

```{r}
add_food_score_log <- function(df, myVar, fbdg_dat){
  # 対数スケールでの閾値（±約10%に相当）
  lower_threshold <- log(0.9)  # ≈ -0.105
  upper_threshold <- log(1.1)  # ≈ 0.095
  
  df <- df %>%
    mutate(across(all_of(myVar),
      ~ {
        log_fbdg <- log(fbdg_dat[[cur_column()]])
        case_when(
          . >= (log_fbdg + lower_threshold) & 
          . < (log_fbdg + upper_threshold) ~ 1,
          . >= (log_fbdg + upper_threshold) ~ 2,
          . < (log_fbdg + lower_threshold) ~ 3,
          !is.na(.) ~ NA_real_,
          TRUE ~ NA_real_
        )
      },
      .names = "{.col}_score"
    ))
  
  return(df)
}
```

### 注意点と代替案

**閾値の再検討**

対数変換後も±10%の基準を使用していますが、研究の目的によっては以下の代替案も検討できます:

-   **標準偏差ベース**: 対数変換後の分布の標準偏差を用いた閾値設定
-   **パーセンタイルベース**: 集団分布に基づく相対的な評価
-   **異なる閾値**: 過剰摂取と不足で異なる基準を設定（栄養学的により適切な場合がある）

**ゼロ値の処理**

消費量がゼロの観測値がある場合、`log(0) = -Inf`となるため、以下の対応が必要です:

```{r}
# 対数変換前にゼロ値を処理
df <- df %>%
  mutate(across(all_of(myVar),
    ~ case_when(
      . == 0 ~ NA_real_,  # または小さな定数を加える: log(. + 0.001)
      TRUE ~ log(.)
    ),
    .names = "log_{.col}"
  ))
```

### 推奨事項

1.  **対数スケールでスコア評価を実施**してください（上記のコードを使用）
2.  分析結果を報告する際は、「対数変換後の消費量に基づくスコアリング」であることを明記
3.  元のスケールと対数スケールの両方でスコア分布を比較し、妥当性を確認
4.  ゼロ値の処理方針を明確に定義し、文書化

この方法により、消費量のばらつきに対して頑健で、統計的により適切な評価が可能になります。

------------------------------------------------------------------------

## 対数変換（log1p）後のスコア評価方法

食品消費量を `log1p()` で対数変換する場合も、スコア評価は変換後の値同士を比較するほうが一貫性が保たれます。具体的には、摂取基準（fbdg_dat）も同じく `log1p()` により変換し、変換後の数値で「90–110%」の範囲を判定します。

### 実装例

```{r}
add_food_score_log1p <- function(df, myVar, fbdg_dat){
  # 対数変換後の推奨値をリスト化
  log1p_fbdg_lower <- map_dbl(fbdg_dat, ~ log1p(0.9 * .x))
  log1p_fbdg_upper <- map_dbl(fbdg_dat, ~ log1p(1.1 * .x))
  
  df %>%
    # 消費量を log1p 変換して新規列に
    mutate(across(all_of(myVar),
                  ~ log1p(.),
                  .names = "log1p_{.col}")) %>%
    # スコア列の追加
    mutate(across(starts_with("log1p_"),
                  ~ {
                    var <- sub("^log1p_", "", cur_column())
                    lower <- log1p_fbdg_lower[[var]]
                    upper <- log1p_fbdg_upper[[var]]
                    case_when(
                      . >= lower & . < upper ~ 1,
                      . >= upper           ~ 2,
                      . < lower            ~ 3,
                      TRUE                 ~ NA_real_
                    )
                  },
                  .names = "{sub('log1p_', '', .col)}_score"))
}
```

### ポイント解説

-   **推奨値の変換** 各食品群の基準値に対し、まず 0.9×・1.1× を計算し、それぞれ `log1p()` で変換して閾値とします。
-   **変換後の比較** 消費量も `log1p()` で変換し、同じスケールの数値同士を比較することで、±10% の範囲判定が対数空間でも正しく機能します。
-   **ゼロ値への対応** `log1p(0)=0` となるため、エラーなく扱えます。もし「消費ゼロを欠測扱い」したい場合は、`log1p()` の前に `case_when(.==0~NA_real_, TRUE~.)` を挟むとよいでしょう。

この方法により、`log1p()` 変換後のばらつき抑制効果を活かしつつ、元の「90–110%」判定基準を対数空間に正しく反映できます。
