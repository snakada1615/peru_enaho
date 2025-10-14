<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" style="height:64px;margin-right:32px"/>

## svyboxplotを使った複数グラフの画面レイアウト指定について

あなたのコードで8つのグラフのうち最初の4つしか描画されない問題は、**レイアウト設定と実際に描画するグラフ数のミスマッチ**が原因です。

### 問題の原因

現在のコード設定では：

-   `par(mfrow = c(2, 2))` で **4つのプロット位置**（2行×2列）を準備
-   しかし実際には **8つのグラフ**（myVar）を描画しようとしている

Rの`par(mfrow)`は指定した数の位置しか確保しないため、5つ目以降のプロットは描画されません。[^svyboxplotを使った複数グラフの画面レイアウト指定について-1],[^svyboxplotを使った複数グラフの画面レイアウト指定について-2],[^svyboxplotを使った複数グラフの画面レイアウト指定について-3]

[^svyboxplotを使った複数グラフの画面レイアウト指定について-1]: <https://bookdown.org/ndphillips/YaRrr/arranging-plots-with-parmfrow-and-layout.html>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-2]: <https://r-charts.com/base-r/combining-plots/>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-3]: <https://www.theanalysisfactor.com/r-multiple-graphs/>

### 解決方法

#### 1. レイアウトを2×4に変更（推奨）

8個のグラフを1つのファイルに収めたい場合：

```{r}
# 2×4のレイアウトに変更（8つのプロット位置を確保）
par(mfrow = c(2, 4), mar = c(4, 4, 3, 1))
```

#### 2. layout()関数を使用

より柔軟なレイアウトが必要な場合：

```{r}
# 8つのプロット位置を持つマトリックスを作成
layout_matrix <- matrix(1:8, nrow = 2, ncol = 4, byrow = TRUE)
layout(layout_matrix)
```

#### 3. PNG出力サイズの調整

8つのグラフを配置する場合、出力画像サイズも調整が必要です：

```{r}
# 幅を増やして8つのグラフに対応
png(filename = file.path(save_folder, year_current, "descriptive", 
                        paste0("boxplot_quintile_", quintile, ".png")), 
    width = 2400, height = 800, res = 120)  # 幅を2倍に調整
```

### 修正版コード例

```{r}
for(quintile in 1:5) {
  subset_design <- subset(enaho_design, inc_quintile == as.character(quintile))
  
  # PNG出力設定（8つのグラフに対応した幅）
  png(filename = file.path(save_folder, year_current, "descriptive", 
                          paste0("boxplot_quintile_", quintile, ".png")), 
      width = 2400, height = 800, res = 120)
  
  # 2×4レイアウト設定（8つのプロット位置を確保）
  par(mfrow = c(2, 4), mar = c(4, 4, 3, 1))
  
  for(var in myVar) {
    tryCatch({
      log1p_var <- paste0(var, "_log1p")
      svyboxplot(
        formula = as.formula(paste(log1p_var, "~ area")),
        design = subset_design,
        main = paste(var, "- income_quintile", quintile),
        ylab = var,
        xlab = "area",
        las = 2,
        cex.axis = 0.6,
        all.outliers = TRUE
      )
    }, error = function(e) {
      plot.new()
      title(paste("error:", var, "- income_quintile", quintile))
      text(0.5, 0.5, "not enough data", cex = 1.5)
    })
  }
  
  dev.off()
  cat("income_quintile", quintile, "boxplot complete!\n")
}
```

### 代替案：複数ページに分割

8つのグラフが1つの画像では見づらい場合は、2つのファイルに分割することも可能です：[^svyboxplotを使った複数グラフの画面レイアウト指定について-4]

[^svyboxplotを使った複数グラフの画面レイアウト指定について-4]: <https://stat.ethz.ch/pipermail/r-help/2016-January/435522.html>

```{r}
# 最初の4つのグラフ
par(mfrow = c(2, 2))
for(i in 1:4) {
  # 最初の4つの変数をプロット
}

# 次の4つのグラフ（新しいPNGファイル）
par(mfrow = c(2, 2))
for(i in 5:8) {
  # 残りの4つの変数をプロット
}
```

この修正により、8つすべてのsvyboxplotが正しく描画されるはずです。 [^svyboxplotを使った複数グラフの画面レイアウト指定について-5],[^svyboxplotを使った複数グラフの画面レイアウト指定について-6],[^svyboxplotを使った複数グラフの画面レイアウト指定について-7],[^svyboxplotを使った複数グラフの画面レイアウト指定について-8],[^svyboxplotを使った複数グラフの画面レイアウト指定について-9],[^svyboxplotを使った複数グラフの画面レイアウト指定について-10],[^svyboxplotを使った複数グラフの画面レイアウト指定について-11],[^svyboxplotを使った複数グラフの画面レイアウト指定について-12],[^svyboxplotを使った複数グラフの画面レイアウト指定について-13],[^svyboxplotを使った複数グラフの画面レイアウト指定について-14],[^svyboxplotを使った複数グラフの画面レイアウト指定について-15],[^svyboxplotを使った複数グラフの画面レイアウト指定について-16],[^svyboxplotを使った複数グラフの画面レイアウト指定について-17],[^svyboxplotを使った複数グラフの画面レイアウト指定について-18],[^svyboxplotを使った複数グラフの画面レイアウト指定について-19],[^svyboxplotを使った複数グラフの画面レイアウト指定について-20],[^svyboxplotを使った複数グラフの画面レイアウト指定について-21],[^svyboxplotを使った複数グラフの画面レイアウト指定について-22],[^svyboxplotを使った複数グラフの画面レイアウト指定について-23],[^svyboxplotを使った複数グラフの画面レイアウト指定について-24],[^svyboxplotを使った複数グラフの画面レイアウト指定について-25],[^svyboxplotを使った複数グラフの画面レイアウト指定について-26],[^svyboxplotを使った複数グラフの画面レイアウト指定について-27],[^svyboxplotを使った複数グラフの画面レイアウト指定について-28],[^svyboxplotを使った複数グラフの画面レイアウト指定について-29],[^svyboxplotを使った複数グラフの画面レイアウト指定について-30],[^svyboxplotを使った複数グラフの画面レイアウト指定について-31],[^svyboxplotを使った複数グラフの画面レイアウト指定について-32],[^svyboxplotを使った複数グラフの画面レイアウト指定について-33],[^svyboxplotを使った複数グラフの画面レイアウト指定について-34],[^svyboxplotを使った複数グラフの画面レイアウト指定について-35],[^svyboxplotを使った複数グラフの画面レイアウト指定について-36],[^svyboxplotを使った複数グラフの画面レイアウト指定について-37],[^svyboxplotを使った複数グラフの画面レイアウト指定について-38],[^svyboxplotを使った複数グラフの画面レイアウト指定について-39],[^svyboxplotを使った複数グラフの画面レイアウト指定について-40],[^svyboxplotを使った複数グラフの画面レイアウト指定について-41],[^svyboxplotを使った複数グラフの画面レイアウト指定について-42],[^svyboxplotを使った複数グラフの画面レイアウト指定について-43],[^svyboxplotを使った複数グラフの画面レイアウト指定について-44],[^svyboxplotを使った複数グラフの画面レイアウト指定について-45],[^svyboxplotを使った複数グラフの画面レイアウト指定について-46],[^svyboxplotを使った複数グラフの画面レイアウト指定について-47]

[^svyboxplotを使った複数グラフの画面レイアウト指定について-5]: [<https://www.mathworks.com/matlabcentral/answers/54008-plotting-multiple-boxplots-in-the-same-figure-window>]{style="display:none"}

[^svyboxplotを使った複数グラフの画面レイアウト指定について-6]: <https://ggplot2-book.org/arranging-plots.html>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-7]: <https://cran.r-project.org/web/packages/egg/vignettes/Ecosystem.html>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-8]: <https://www.geeksforgeeks.org/data-visualization/creating-multiple-boxplots-on-the-same-graph-from-a-dictionary/>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-9]: <https://towardsdatascience.com/create-custom-layouts-in-your-r-plots-eb7488e6f19f/>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-10]: <https://r-graph-gallery.com/71-split-screen-with-par-mfrow.html>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-11]: <https://www.youtube.com/watch?v=K-GKhyy8KiY>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-12]: <https://www.youtube.com/watch?v=c4FKRevUcT4>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-13]: <https://www.staff.ncl.ac.uk/stephen.juggins/data/Iowa2007/PlottingTips.pdf>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-14]: <https://www.mathworks.com/matlabcentral/answers/55329-plotting-multiple-boxplots-within-the-same-plot-figure>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-15]: <https://cran.r-project.org/web/packages/ggraph/vignettes/Layouts.html>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-16]: <https://jtr13.github.io/cc20/laying-out-multiple-plots-for-baseplot-and-ggplot.html>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-17]: <https://forum.posit.co/t/multiple-box-plots/47878>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-18]: <https://qiita.com/okd46/items/bd8ff67c39016d4a3dd7>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-19]: <https://stackoverflow.com/questions/41518423/multiple-plots-per-page-in-a-for-loop>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-20]: <https://ebreha.com/merge-graph/>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-21]: <https://stackoverflow.com/questions/38810854/how-to-use-layout-function-in-r>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-22]: <https://qiita.com/sazya/items/ab641eb589a1d4d375db>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-23]: <http://eau.uijin.com/advgraphs/layout.html>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-24]: <https://www.rdocumentation.org/packages/graphics/versions/3.6.2/topics/layout>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-25]: <https://myopomme.hatenablog.com/entry/20110412/1302617692>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-26]: <http://takenaka-akio.org/doc/r_auto/chapter_06.html>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-27]: <http://www.countbio.com/web_pages/left_object/R_for_biology/R_fundamentals/multiple_plots_R.html>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-28]: <https://nfunao.web.fc2.com/files/R-graphics.pdf>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-29]: <https://cran.r-project.org/web/packages/semptools/vignettes/layout_matrix.html>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-30]: <http://tips-r.blogspot.com/2014/05/parmfrowmfcol.html>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-31]: <https://stackoverflow.com/questions/13829365/exporting-multiple-panels-of-plots-and-data-to-png-in-the-style-layout-work>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-32]: <https://stackoverflow.com/questions/23278440/plot-two-graphs-on-same-chart-r-ggplot2-parmfrow>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-33]: <https://stats.biopapyrus.jp/r/graph/splitscreen.html>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-34]: <https://www.geeksforgeeks.org/r-language/plot-multiple-boxplots-in-one-graph-in-r/>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-35]: <https://mkkmkk.com/wp-content/uploads/Green1-4-1R.pdf>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-36]: <https://helleng.github.io/Data_Mgt_Analysis_and_Graphics_R/R_Essentials/chap8.html>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-37]: <https://php-1511-2511.github.io/labs/lab6.html>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-38]: <https://www.andrewheiss.com/blog/2016/12/08/save-base-graphics-as-pseudo-objects-in-r/>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-39]: <https://mi-chan-nel.com/mfrow-introduction/>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-40]: <https://rpubs.com/dakotakay2/695043>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-41]: <https://r-survey.r-forge.r-project.org/survey/survey-wss-2010.pdf>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-42]: <https://d31kydh6n6r5j5.cloudfront.net/uploads/sites/66/2019/04/RPlot.pdf>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-43]: <https://stackoverflow.com/questions/14604439/plot-multiple-boxplot-in-one-graph>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-44]: <https://stackoverflow.com/questions/33288009/arrange-r-plots-in-a-custom-layout>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-45]: <https://stackoverflow.com/questions/74833371/plot-with-parmfrow-c3-2>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-46]: <https://www.reddit.com/r/rstats/comments/eddpgz/svyboxplot_plotting_different_categories/>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-47]: <https://stat.ethz.ch/R-manual/R-devel/library/graphics/help/layout.html>

::: {align="center"}
⁂
:::

------------------------------------------------------------------------

## 4つおきにページ分割するためのRコード修正方法

エラーの原因は、Rでは `mod()` 関数ではなく **`%%` 演算子**を使って余剰（モジュロ）を計算する必要があることです。[^svyboxplotを使った複数グラフの画面レイアウト指定について-48],[^svyboxplotを使った複数グラフの画面レイアウト指定について-49],[^svyboxplotを使った複数グラフの画面レイアウト指定について-50]

[^svyboxplotを使った複数グラフの画面レイアウト指定について-48]: <https://stackoverflow.com/questions/38524774/understanding-the-result-of-modulo-operator>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-49]: <https://quantifyinghealth.com/modulo-operator-in-r-examples/>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-50]: <https://www.w3schools.com/r/r_operators.asp>

### 修正されたコード

以下のように修正してください：

``` r
for(quintile in 1:5) {
  subset_design <- subset(enaho_design, inc_quintile == as.character(quintile))
  
  # PNG出力設定
  png(filename = file.path(save_folder, year_current, "descriptive", 
                          paste0("boxplot_quintile_", quintile, ".png")), 
      width = 1200, height = 800, res = 120)
  
  for(i in 1:length(myVar)) {
    var <- myVar[i]
    
    # 4つグラフを描画するごとに新しいレイアウトを設定
    if (i %% 4 == 1) {  # mod(i, 4) を i %% 4 に変更
      # レイアウト設定（2x2で4変数を配置）
      par(mfrow = c(2, 2), mar = c(4, 4, 3, 1))  
    }
    
    tryCatch({
      log1p_var <- paste0(var, "_log1p")
      svyboxplot(
        formula = as.formula(paste(log1p_var, "~ area")),
        design = subset_design,
        main = paste(var, "- income_quintile", quintile),
        ylab = var,
        xlab = "area",
        las = 2,
        cex.axis = 0.6,
        all.outliers = TRUE
      )
    }, error = function(e) {
      plot.new()
      title(paste("error:", var, "- income_quintile", quintile))
      text(0.5, 0.5, "not enough data", cex = 1.5)
    })
  }
  
  dev.off()
  cat("income_quintile", quintile, "boxplot complete!\n")
}
```

### Rのモジュロ演算子について

Rでは以下の算術演算子が利用可能です：[^svyboxplotを使った複数グラフの画面レイアウト指定について-51],[^svyboxplotを使った複数グラフの画面レイアウト指定について-52]

[^svyboxplotを使った複数グラフの画面レイアウト指定について-51]: <https://www.w3schools.com/r/r_operators.asp>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-52]: <https://www.tutorialgateway.org/r-arithmetic-operators/>

-   **`%%`**: モジュロ演算子（余剰を返す）
-   **`%/%`**: 整数除算演算子（商の整数部分を返す）

### 使用例

``` r
# モジュロ演算子の例
5 %% 2    # 結果: 1 (5を2で割った余り)
8 %% 4    # 結果: 0 (8を4で割った余りは0)
10 %% 3   # 結果: 1 (10を3で割った余り)

# 整数除算演算子の例  
5 %/% 2   # 結果: 2 (5を2で割った商の整数部分)
10 %/% 3  # 結果: 3 (10を3で割った商の整数部分)
```

### ロジックの説明

修正されたコードでは：

-   `i %% 4 == 1` が真となるのは `i = 1, 5, 9, 13...` の時
-   つまり1番目、5番目、9番目のグラフで新しい2×2レイアウトが設定される
-   各レイアウトで4つのグラフ（位置1-4）が描画される

これにより、8個のmyVar変数が2ページ（最初の4つ + 次の4つ）に分割されて表示されます。[^svyboxplotを使った複数グラフの画面レイアウト指定について-53],[^svyboxplotを使った複数グラフの画面レイアウト指定について-54] [^svyboxplotを使った複数グラフの画面レイアウト指定について-55],[^svyboxplotを使った複数グラフの画面レイアウト指定について-56],[^svyboxplotを使った複数グラフの画面レイアウト指定について-57],[^svyboxplotを使った複数グラフの画面レイアウト指定について-58],[^svyboxplotを使った複数グラフの画面レイアウト指定について-59],[^svyboxplotを使った複数グラフの画面レイアウト指定について-60],[^svyboxplotを使った複数グラフの画面レイアウト指定について-61],[^svyboxplotを使った複数グラフの画面レイアウト指定について-62],[^svyboxplotを使った複数グラフの画面レイアウト指定について-63],[^svyboxplotを使った複数グラフの画面レイアウト指定について-64],[^svyboxplotを使った複数グラフの画面レイアウト指定について-65],[^svyboxplotを使った複数グラフの画面レイアウト指定について-66],[^svyboxplotを使った複数グラフの画面レイアウト指定について-67],[^svyboxplotを使った複数グラフの画面レイアウト指定について-68]

[^svyboxplotを使った複数グラフの画面レイアウト指定について-53]: <https://quantifyinghealth.com/modulo-operator-in-r-examples/>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-54]: <https://www.theanalysisfactor.com/r-multiple-graphs/>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-55]: [<https://hyperskill.org/university/r-language/modulo-operation-in-r>]{style="display:none"}

[^svyboxplotを使った複数グラフの画面レイアウト指定について-56]: <https://www.reddit.com/r/programminghorror/comments/hj7d2z/how_to_find_remainder_without_using_modulo/>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-57]: <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Remainder>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-58]: <https://www.reddit.com/r/programminghorror/comments/v733ak/we_needed_a_differentiable_version_of_x_mod_2/>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-59]: <https://campus.datacamp.com/courses/introduction-to-r-for-finance/the-basics?ex=3>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-60]: <http://adv-r.had.co.nz/Functionals.html>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-61]: <https://en.wikipedia.org/wiki/Modulo>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-62]: <https://stat.ethz.ch/pipermail/r-help/2005-January/064818.html>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-63]: <https://www.reddit.com/r/learnpython/comments/181ngbk/modulo_operator/>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-64]: <https://www.youtube.com/watch?v=g8-voq7SXag>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-65]: <https://stackoverflow.com/questions/11670176/and-for-the-remainder-and-the-quotient>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-66]: <https://stackoverflow.com/questions/45105279/mod-function-in-r-equivalent-for-matlab>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-67]: <https://stat.ethz.ch/R-manual/R-devel/library/base/help/Arithmetic.html>

[^svyboxplotを使った複数グラフの画面レイアウト指定について-68]: <https://lemire.me/blog/2016/06/27/a-fast-alternative-to-the-modulo-reduction/>

::: {align="center"}
⁂
:::

------------------------------------------------------------------------

# この場合、保存用のファイル名が各ループで一つなので、２枚のグラフ描画しても1枚の出力になりませんか？

ファイル名はループごとに一つしか生成していないので、確かに内側の4変数ごとにページを切り替えても、最後に閉じられるのは最初に開いた１つのPNGデバイスだけになります。そのため、**4つごとに新しくファイルを開く**か、**マルチページPDFデバイス**を使う必要があります。

------------------------------------------------------------------------

### ① 4変数ごとにPNGファイルを分ける

``` r
for(quintile in 1:5) {
  subset_design <- subset(enaho_design, inc_quintile == as.character(quintile))
  
  page <- 1
  for(i in seq_along(myVar)) {
    # 新しいページ（ファイル）が必要なとき
    if (i %% 4 == 1) {
      # 既存デバイスがあれば閉じる
      if (exists("png_open") && png_open) dev.off()
      
      # 新PNGファイルをオープン
      png(filename = file.path(save_folder, year_current, "descriptive",
                               paste0("boxplot_quintile_", quintile, "_page", page, ".png")),
          width = 1200, height = 800, res = 120)
      par(mfrow = c(2, 2), mar = c(4, 4, 3, 1))
      png_open <- TRUE
      page <- page + 1
    }
    
    # プロット処理
    var <- myVar[i]
    tryCatch({
      log1p_var <- paste0(var, "_log1p")
      svyboxplot(
        as.formula(paste(log1p_var, "~ area")),
        design = subset_design,
        main = paste(var, "- income_quintile", quintile),
        ylab = var, xlab = "area",
        las = 2, cex.axis = 0.6, all.outliers = TRUE
      )
    }, error = function(e) {
      plot.new()
      title(paste("error:", var))
      text(0.5, 0.5, "not enough data", cex = 1.5)
    })
  }
  
  # 最後のデバイスを閉じる
  if (exists("png_open") && png_open) dev.off()
  rm(png_open)
  cat("income_quintile", quintile, "completed with", page - 1, "pages\n")
}
```

-   `page` カウンタでファイル名にページ番号を付与
-   4変数ごとに `dev.off()` → `png()` を繰り返し呼び出し

------------------------------------------------------------------------

### ② マルチページPDFを使う

PNGでは単一ページ出力の制約があるため、PDFデバイスを使うと1ファイル内に複数ページを保持できます。

``` r
for(quintile in 1:5) {
  subset_design <- subset(enaho_design, inc_quintile == as.character(quintile))
  
  # PDFデバイスをオープン（マルチページ対応）
  pdf(file = file.path(save_folder, year_current, "descriptive",
                       paste0("boxplot_quintile_", quintile, ".pdf")),
      width = 12, height = 8)
  
  for(i in seq_along(myVar)) {
    var <- myVar[i]
    
    # 4変数ごとに新ページ
    if (i %% 4 == 1) par(mfrow = c(2, 2), mar = c(4, 4, 3, 1))
    
    tryCatch({
      log1p_var <- paste0(var, "_log1p")
      svyboxplot(
        as.formula(paste(log1p_var, "~ area")),
        design = subset_design,
        main = paste(var, "- income_quintile", quintile),
        ylab = var, xlab = "area",
        las = 2, cex.axis = 0.6, all.outliers = TRUE
      )
    }, error = function(e) {
      plot.new()
      title(paste("error:", var))
      text(0.5, 0.5, "not enough data", cex = 1.5)
    })
    
    # 4つ描画後に新ページ開始
    if (i %% 4 == 0 && i != length(myVar)) {
      grid::grid.newpage()
    }
  }
  
  dev.off()
  cat("income_quintile", quintile, "PDF complete!\n")
}
```

-   **`pdf()`** はデフォルトでマルチページをサポート
-   `grid.newpage()` でページ区切り
-   1つのPDFに全ページが格納されるので管理が簡単

------------------------------------------------------------------------

これらの方法により、4つおきにページ分割されたグラフを**重複なく**、**望みのファイル形式**で保存できます。
