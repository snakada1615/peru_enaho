<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" style="height:64px;margin-right:32px"/>

## dplyrの`summarise()`警告メッセージの解決方法

この警告は **dplyr 1.0以降で追加された情報メッセージ** で、`summarise()`関数が複数のグループで実行された際のグループ構造について知らせるものです。[^(4-summarise(にはungroup(でなく.by(-1][^(4-summarise(にはungroup(でなく.by(-2][^(4-summarise(にはungroup(でなく.by(-3]

[^(4-summarise(にはungroup(でなく.by(-1]: <https://www.youtube.com/watch?v=PV05D7YOGLE>

[^(4-summarise(にはungroup(でなく.by(-2]: <https://www.andrewheiss.com/blog/2024/04/04/group_by-summarize-ungroup-animations/>

[^(4-summarise(にはungroup(でなく.by(-3]: <https://statisticsglobe.com/dplyr-message-summarise-has-grouped-output-r/>

### 警告が出る理由

`group_by(AÑO, MES, CONGLOME, VIVIENDA, HOGAR)`で5つの変数でグループ化した後、`summarise()`を実行すると、**デフォルトで最後のグループ変数（HOGAR）のみが削除され、残りの4つの変数（AÑO, MES, CONGLOME, VIVIENDA）によるグループ構造が維持される**ためです[^(4-summarise(にはungroup(でなく.by(-4][^(4-summarise(にはungroup(でなく.by(-5]。

[^(4-summarise(にはungroup(でなく.by(-4]: <https://www.andrewheiss.com/blog/2024/04/04/group_by-summarize-ungroup-animations/>

[^(4-summarise(にはungroup(でなく.by(-5]: <https://stackoverflow.com/questions/62140483/how-to-interpret-dplyr-message-summarise-regrouping-output-by-x-override>

コードの最後に`ungroup()`を付けていても、`summarise()`の段階で既にこのメッセージが表示されます。

### 解決方法

以下のいずれかの方法で警告を解決できます：

**方法1: `.groups = "drop"`引数を使用**

``` r
df_family_size <- df_mod4 %>%
  # 既存のコード...
  group_by(AÑO, MES, CONGLOME, VIVIENDA, HOGAR) %>%
  summarise(
    family_size = n(),
    family_size_ame = sum(adult_male_equivalent),
    .groups = "drop"  # すべてのグループを削除
  )
```

**方法2: グローバル設定で警告を無効化**

``` r
options(dplyr.summarise.inform = FALSE)
```

**方法3: `.by`引数を使用（dplyr 1.1.0以降）**

``` r
df_family_size <- df_mod4 %>%
  # group_by()の代わりに.byを使用
  summarise(
    family_size = n(),
    family_size_ame = sum(adult_male_equivalent),
    .by = c(AÑO, MES, CONGLOME, VIVIENDA, HOGAR)
  )
```

### 推奨される解決方法

**方法1の`.groups = "drop"`** が最も推奨されます。これは：[^(4-summarise(にはungroup(でなく.by(-6][^(4-summarise(にはungroup(でなく.by(-7]

[^(4-summarise(にはungroup(でなく.by(-6]: <https://www.andrewheiss.com/blog/2024/04/04/group_by-summarize-ungroup-animations/>

[^(4-summarise(にはungroup(でなく.by(-7]: <https://statisticsglobe.com/dplyr-message-summarise-has-grouped-output-r/>

-   コードの意図が明確になる
-   警告メッセージが表示されない
-   `ungroup()`が不要になる
-   グループ構造を明示的に制御できる

この警告は **データの処理結果に影響を与えない** 情報メッセージですが、明示的に対応することでコードがより明確になります。[^(4-summarise(にはungroup(でなく.by(-8][^(4-summarise(にはungroup(でなく.by(-9] [^(4-summarise(にはungroup(でなく.by(-10][^(4-summarise(にはungroup(でなく.by(-11][^(4-summarise(にはungroup(でなく.by(-12][^(4-summarise(にはungroup(でなく.by(-13][^(4-summarise(にはungroup(でなく.by(-14][^(4-summarise(にはungroup(でなく.by(-15][^(4-summarise(にはungroup(でなく.by(-16][^(4-summarise(にはungroup(でなく.by(-17][^(4-summarise(にはungroup(でなく.by(-18][^(4-summarise(にはungroup(でなく.by(-19][^(4-summarise(にはungroup(でなく.by(-20][^(4-summarise(にはungroup(でなく.by(-21][^(4-summarise(にはungroup(でなく.by(-22][^(4-summarise(にはungroup(でなく.by(-23]

[^(4-summarise(にはungroup(でなく.by(-8]: <https://statisticsglobe.com/dplyr-message-summarise-has-grouped-output-r/>

[^(4-summarise(にはungroup(でなく.by(-9]: <https://forum.posit.co/t/summarise-has-grouped-output-by-x-you-can-override-using-the-groups-argument/174520>

[^(4-summarise(にはungroup(でなく.by(-10]: [<https://forum.posit.co/t/dplyr-1-0-0-summarize-summarise-inform-warnings/73006>]{style="display:none"}

[^(4-summarise(にはungroup(でなく.by(-11]: <https://bookdown.org/yih_huynh/Guide-to-R-Book/groupby.html>

[^(4-summarise(にはungroup(でなく.by(-12]: <https://www.reddit.com/r/rprogramming/comments/gw6sah/what_does_this_warning_in_dplyr_mean_re_grouping/>

[^(4-summarise(にはungroup(でなく.by(-13]: <https://www.tidyverse.org/blog/2023/02/dplyr-1-1-0-per-operation-grouping/>

[^(4-summarise(にはungroup(でなく.by(-14]: <https://dplyr.tidyverse.org/reference/summarise.html>

[^(4-summarise(にはungroup(でなく.by(-15]: <https://cran.r-project.org/web/packages/dplyr/dplyr.pdf>

[^(4-summarise(にはungroup(でなく.by(-16]: <https://rstats-tips.net/2020/07/31/get-rid-of-info-of-dplyr-when-grouping-summarise-regrouping-output-by-species-override-with-groups-argument/>

[^(4-summarise(にはungroup(でなく.by(-17]: <https://www.jaysong.net/RBook/datahandling2.html>

[^(4-summarise(にはungroup(でなく.by(-18]: <https://dplyr.tidyverse.org/articles/grouping.html>

[^(4-summarise(にはungroup(でなく.by(-19]: <https://notchained.hatenablog.com/entry/2020/06/28/134109>

[^(4-summarise(にはungroup(でなく.by(-20]: <https://www.reddit.com/r/Rlanguage/comments/h9s1cy/dplyr_ungroup/>

[^(4-summarise(にはungroup(でなく.by(-21]: <https://note.com/mitti1210/n/n279179e760eb>

[^(4-summarise(にはungroup(でなく.by(-22]: <https://github.com/tidyverse/dplyr/issues/6675>

[^(4-summarise(にはungroup(でなく.by(-23]: <https://www.reddit.com/r/rprogramming/comments/180q62j/r_for_data_science_question/>

::: {align="center"}
⁂
:::
