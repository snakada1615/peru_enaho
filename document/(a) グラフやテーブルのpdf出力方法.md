<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" style="height:64px;margin-right:32px"/>

# pdf() ... dsv.off()を利用したグラフの保存先設定（PDF：マルチページ対応）

```{r}

pdf(file = file.path(save_folder, year_current, "descriptive", paste0("boxplot_quintile\_", quintile, ".pdf")), width = 12, height = 8)

# グラフの描画コード例
boxplot(
  formula = consumption ~ inc_quintile,
  data = df_foodgrp_consumption_capita %>% filter(inc_quintile == quintile),
  main = paste0("Food Group Consumption by Income Quintile ", quintile),
  xlab = "Income Quintile",
  ylab = "Consumption (grams per capita per day)",
  col = "lightblue",
  border = "darkblue"
)

dev.off()

```

このコードのpdf() ... dev.off()は、「RでグラフをPDFファイルとして保存する」ための標準的な方法です。[^(a-グラフやテーブルのpdf出力方法-1],[^(a-グラフやテーブルのpdf出力方法-2],[^(a-グラフやテーブルのpdf出力方法-3]

[^(a-グラフやテーブルのpdf出力方法-1]: <https://www.geeksforgeeks.org/r-language/saving-graphs-as-files-in-r/>

[^(a-グラフやテーブルのpdf出力方法-2]: <https://bookdown.org/ndphillips/YaRrr/saving-plots-to-a-file-with-pdf-jpeg-and-png.html>

[^(a-グラフやテーブルのpdf出力方法-3]: <https://www.geeksforgeeks.org/r-language/how-to-export-multiple-plots-to-pdf-in-r/>

### pdf()の意味

-   `pdf()`は「これから描画するグラフを指定したPDFファイルに出力する」ことをRに指示します。
-   `file = ...`で保存先ファイル名を指定します。
-   `width`や`height`でPDFのページサイズ（インチ単位）を指定します。
-   このコマンド以降に描画されるすべてのグラフは、RのプロットウィンドウではなくPDFファイルに出力されます。[^(a-グラフやテーブルのpdf出力方法-4],[^(a-グラフやテーブルのpdf出力方法-5],[^(a-グラフやテーブルのpdf出力方法-6]

[^(a-グラフやテーブルのpdf出力方法-4]: <https://bookdown.org/ndphillips/YaRrr/saving-plots-to-a-file-with-pdf-jpeg-and-png.html>

[^(a-グラフやテーブルのpdf出力方法-5]: <https://www.geeksforgeeks.org/r-language/how-to-export-multiple-plots-to-pdf-in-r/>

[^(a-グラフやテーブルのpdf出力方法-6]: <https://www.geeksforgeeks.org/r-language/saving-graphs-as-files-in-r/>

### dev.off()の意味

-   `dev.off()`は「PDFファイルへの描画を終了し、ファイルを閉じる」コマンドです。
-   これを実行しないと、PDFファイルが正しく保存されず、ファイルが壊れることがあります。[^(a-グラフやテーブルのpdf出力方法-7],[^(a-グラフやテーブルのpdf出力方法-8]

[^(a-グラフやテーブルのpdf出力方法-7]: <https://www.geeksforgeeks.org/r-language/how-to-export-multiple-plots-to-pdf-in-r/>

[^(a-グラフやテーブルのpdf出力方法-8]: <https://bookdown.org/ndphillips/YaRrr/saving-plots-to-a-file-with-pdf-jpeg-and-png.html>

### まとめ

-   `pdf()`でPDFファイルへの出力を開始し、`dev.off()`で終了します。
-   この間に描画したグラフはすべてPDFファイルに保存されます。
-   ループ内で複数のグラフを描画すれば、1つのPDFファイルに複数ページとして保存されます。[^(a-グラフやテーブルのpdf出力方法-9]

[^(a-グラフやテーブルのpdf出力方法-9]: <https://www.geeksforgeeks.org/r-language/how-to-export-multiple-plots-to-pdf-in-r/>

この仕組みにより、Rのグラフを自動的にファイル保存でき、レポート作成や共有に便利です。[^(a-グラフやテーブルのpdf出力方法-10],[^(a-グラフやテーブルのpdf出力方法-11],[^(a-グラフやテーブルのpdf出力方法-12] [^(a-グラフやテーブルのpdf出力方法-13],[^(a-グラフやテーブルのpdf出力方法-14],[^(a-グラフやテーブルのpdf出力方法-15],[^(a-グラフやテーブルのpdf出力方法-16],[^(a-グラフやテーブルのpdf出力方法-17],[^(a-グラフやテーブルのpdf出力方法-18],[^(a-グラフやテーブルのpdf出力方法-19]

[^(a-グラフやテーブルのpdf出力方法-10]: <https://www.geeksforgeeks.org/r-language/saving-graphs-as-files-in-r/>

[^(a-グラフやテーブルのpdf出力方法-11]: <https://bookdown.org/ndphillips/YaRrr/saving-plots-to-a-file-with-pdf-jpeg-and-png.html>

[^(a-グラフやテーブルのpdf出力方法-12]: <https://www.geeksforgeeks.org/r-language/how-to-export-multiple-plots-to-pdf-in-r/>

[^(a-グラフやテーブルのpdf出力方法-13]: [<https://stackoverflow.com/questions/19288101/r-pdf-usage-inside-a-function>]{style="display:none"}

[^(a-グラフやテーブルのpdf出力方法-14]: <https://www.rdocumentation.org/packages/tm/versions/0.3-3/topics/readPDF>

[^(a-グラフやテーブルのpdf出力方法-15]: <https://stackoverflow.com/questions/19288101/r-pdf-usage-inside-a-function/19288874>

[^(a-グラフやテーブルのpdf出力方法-16]: <https://stat.ethz.ch/R-manual/R-devel/library/grDevices/html/pdf.html>

[^(a-グラフやテーブルのpdf出力方法-17]: <https://cran.r-project.org/doc/manuals/R-intro.pdf>

[^(a-グラフやテーブルのpdf出力方法-18]: <http://library.virginia.edu/data/articles/reading-pdf-files-into-r-for-text-mining>

[^(a-グラフやテーブルのpdf出力方法-19]: <https://www.stat.berkeley.edu/~statcur/Workshop2/Presentations/functions.pdf>

::: {align="center"}
⁂
:::
