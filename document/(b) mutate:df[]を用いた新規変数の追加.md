<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" style="height:64px;margin-right:32px"/>

# ポイントまとめ：mutateとdf[[var]]による新変数作成

## 1. **目的**

-   複数の列（例：`myVar`に含まれる列）に対して、条件分岐（90以上110未満なら1、それ以外なら0）で新しい変数（列）を作成する。

## 2. \*\*mutate + across + case_when の方法（推奨）

-   ループ不要で、複数列を一括処理できる。
-   可読性・保守性が高い。

``` r
library(dplyr)
df <- df %>%
  mutate(across(
    all_of(myVar),
    ~ case_when(
        . >= 90 & . < 110 ~ 1,
        !is.na(.) ~ 0,
        TRUE ~ NA_real_
      ),
    .names = "{.col}_optimal"
  ))
```

-   `across()`で複数列を一括処理。
-   `.names`で新しい列名を自動生成。
-   `case_when()`で条件分岐。

## 3. \*\*df[[var]]を使う方法（ベースR流）

-   ループで各列を個別に処理。
-   動的な変数名生成や細かい制御が可能。

``` r
for (var in myVar) {
  df[[paste0(var, "_optimal")]] <- case_when(
    df[[var]] >= 90 & df[[var]] < 110 ~ 1,
    !is.na(df[[var]]) ~ 0,
    TRUE ~ NA_real_
  )
}
```

-   各列ごとに新しい列を追加。
-   ループ処理が必要。

## 4. **使い分けのポイント**

-   **mutate + across**: 複数列を一括処理したい、tidyverse流で書きたい場合に最適。
-   **df[[var]] + ループ**: 動的な列名生成や細かい制御が必要な場合、ベースRに慣れている場合に有効。

------------------------------------------------------------------------

もしご自身のデータや目的に合わせて、さらに具体的なコード例や解説が必要であれば、コースや学習レベルを教えてください。より詳しくカスタマイズできます。 [^mutatedfを用いた新規変数の追加-1],[^mutatedfを用いた新規変数の追加-2],[^mutatedfを用いた新規変数の追加-3],[^mutatedfを用いた新規変数の追加-4],[^mutatedfを用いた新規変数の追加-5],[^mutatedfを用いた新規変数の追加-6],[^mutatedfを用いた新規変数の追加-7],[^mutatedfを用いた新規変数の追加-8],[^mutatedfを用いた新規変数の追加-9],[^mutatedfを用いた新規変数の追加-10]

[^mutatedfを用いた新規変数の追加-1]: [<https://qiita.com/masatotezuka/items/f166edb2969a3f048163>]{style="display:none"}

[^mutatedfを用いた新規変数の追加-2]: <https://zenn.dev/nora_goes_far/articles/b8cf1b96ea6bcc>

[^mutatedfを用いた新規変数の追加-3]: <https://doubtpad.hatenablog.com/entry/2020/02/14/004013>

[^mutatedfを用いた新規変数の追加-4]: <https://izunyan.github.io/gisho12/mutate.html>

[^mutatedfを用いた新規変数の追加-5]: <https://www.jaysong.net/tutorial/R/dplyr_intro.html>

[^mutatedfを用いた新規変数の追加-6]: <https://qiita.com/swathci/items/8d626865638079d13665>

[^mutatedfを用いた新規変数の追加-7]: <https://tam07pb915.com/2021/08/22/r-mutate-and-across/>

[^mutatedfを用いた新規変数の追加-8]: <https://ill-identified.hatenablog.com/entry/2021/09/18/130716>

[^mutatedfを用いた新規変数の追加-9]: <https://www.jaysong.net/RBook/datahandling3.html>

[^mutatedfを用いた新規変数の追加-10]: <https://nissinbo.github.io/medical_database_RBook/%E3%83%87%E3%83%BC%E3%82%BF%E7%B7%A8%E9%9B%86.html>

::: {align="center"}
⁂
:::
