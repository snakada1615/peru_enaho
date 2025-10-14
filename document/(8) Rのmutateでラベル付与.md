<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" style="height:64px;margin-right:32px"/>

# ポイントまとめ

-   **`labelled()`で値ラベルと変数ラベルを同時指定**

``` r
x <- labelled(
  labels = c("ラベル1" = 1, "ラベル2" = 2),
  label  = "変数説明"
)
```

```         
- `labels`：値ラベル（値と文字列の対応）
- `label`：変数ラベル（変数全体の説明）[^1]
```

-   **`mutate()`内で複数変数を作成する**
    -   各変数の定義をカンマ区切りで並べる

``` r
df %>%
  mutate(
    var1 = ... %>% labelled(...),
    var2 = ... %>% labelled(...),
    var3 = ... %>% labelled(...)
  )
```

-   **後から変数ラベルを追加・変更する**

``` r
df %>%
  set_variable_labels(
    var1 = "新しい説明",
    var2 = "別の説明"
  )
```

-   **可読性向上のコツ**
    -   変数ごとにコメントを入れる
    -   適切な改行とインデントを使う
    -   複雑な処理は段階的に分割する[^ポイントまとめ-1]
-   **実践的な基本コード例**

[^ポイントまとめ-1]: <https://datasciencemore.com/dplyr-mutate/>

``` r
library(dplyr)
library(labelled)

df_labeled <- df %>%
  mutate(
    # 食事頻度を日数で計算＆ラベル付与
    frequency_days = case_when(
      P601D1 == 1 ~ 15,
      P601D1 == 2 ~ 7.5,
      TRUE        ~ 15
    ) %>%
    labelled(
      labels = c("Daily" = 15, "Other" = 7.5),
      label  = "15日間の食事頻度"
    ),

    # カテゴリ分類＆ラベル付与
    freq_cat = case_when(
      P601D1 %in% c(1,2) ~ 1L,
      TRUE               ~ 2L
    ) %>%
    labelled(
      labels = c("高頻度" = 1L, "低頻度" = 2L),
      label  = "頻度カテゴリ"
    )
  ) %>%
  set_variable_labels(
    frequency_days = "食事頻度（日数）",
    freq_cat       = "頻度カテゴリ"
  )
```

::: {align="center"}
⁂
:::
