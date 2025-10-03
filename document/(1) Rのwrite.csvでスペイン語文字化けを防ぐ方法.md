<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" style="height:64px;margin-right:32px"/>

# Rのwrite.csvでスペイン語文字化けを防ぐ方法

**結論：** write.csv（内部的にはwrite.table）に文字コード指定のオプション `fileEncoding="UTF-8"`（あるいはWindows環境でExcel向けにBOM付きの `"UTF-8-BOM"`）を渡せば、スペイン語などのアクセント付き文字も正しく出力できます。

------------------------------------------------------------------------

## 1. 基本的な使い方

``` r
# データフレーム df をUTF-8エンコーディングで書き出す
write.csv(
  df,
  file = "output.csv",
  row.names = FALSE,
  fileEncoding = "UTF-8"
)
```

-   `fileEncoding = "UTF-8"`：書き出し時の文字コードをUTF-8に指定
-   `row.names = FALSE`：行名を不要なら省略（Excelで余計な列ができるのを防ぐ）

------------------------------------------------------------------------

## 2. WindowsのExcelで開く場合

Windows版Excelでは、UTF-8だけだと文字化けすることがあるため、BOM（Byte Order Mark）付きUTF-8を指定します。

``` r
write.csv(
  df,
  file = "output_for_excel.csv",
  row.names = FALSE,
  fileEncoding = "UTF-8-BOM"
)
```

-   `"UTF-8-BOM"`：ExcelがBOMを検出してUTF-8と判断し、文字化けを防ぎます

------------------------------------------------------------------------

## 3. 半角セミコロン区切りの場合

大陸ヨーロッパではセミコロン“;”を区切り文字に使うことが多いので、(`write.csv2`または`sep=";"`)を利用します。

``` r
# write.csv2 はデフォルトで sep=";"、dec=","、fileEncoding="UTF-8" は指定必須
write.csv2(
  df,
  file = "output_semicolon.csv",
  row.names = FALSE,
  fileEncoding = "UTF-8"
)
```

または

``` r
write.table(
  df,
  file = "output_semicolon.csv",
  sep = ";",
  dec = ",",
  row.names = FALSE,
  fileEncoding = "UTF-8"
)
```

------------------------------------------------------------------------

## 4. tidyverse（readrパッケージ）を使う場合

`readr::write_csv()` には `fileEncoding` オプションはないものの、デフォルトでUTF-8出力されます。

``` r
library(readr)
write_csv(
  df,
  "output_readr.csv"
)
```

-   ファイルはUTF-8で保存されるため、Excel用には手動でBOMを付けるか、他の方法で読み込み時にUTF-8を指定します。

------------------------------------------------------------------------

### ポイントまとめ

-   **UNIX/macOS**：`fileEncoding="UTF-8"`
-   **WindowsでExcel向け**：`fileEncoding="UTF-8-BOM"`
-   **セミコロン区切り**：`write.csv2()` または `sep=";"`
-   **tidyverse**：`readr::write_csv()` はUTF-8出力

これらを使い分けることで、スペイン語のアクセント文字を含むデータも文字化けなくCSVに出力できます。

------------------------------------------------------------------------

# macOS上のExcelでUTF-8 CSVが化ける場合の対処法

macOS版Excelは、デフォルトではUTF-8のBOM付きCSVを正しく判別できず、文字化けすることがあります。以下のいずれかの方法で回避できます。

------------------------------------------------------------------------

## 1. UTF-16LE（Little Endian）で書き出す

Excel for Mac はUTF-16LE（BOM付き）を自動認識するため、こちらのエンコーディングで出力します。

``` r
write.table(
  df,
  file       = "output_utf16.csv",
  sep        = ",",
  row.names  = FALSE,
  col.names  = TRUE,
  fileEncoding = "UTF-16LE"
)
```

-   `fileEncoding = "UTF-16LE"`：BOM付きUTF-16 Little Endianで書き出し
-   macOS版Excelでダブルクリックすれば文字化けせず開けます。

------------------------------------------------------------------------

## 2. UTF-8＋BOM付きファイルを手動で作成

`write.csv(fileEncoding="UTF-8")` の後にBOMを書き込む方法です。

``` r
# 1) 一度UTF-8で書き出し
write.csv(
  df,
  file         = "tmp.csv",
  row.names    = FALSE,
  fileEncoding = "UTF-8"
)

# 2) BOM付きファイルを作成
bom <- charToRaw("\ufeff")
data <- readBin("tmp.csv", what = "raw", n = file.info("tmp.csv")$size)
writeBin(c(bom, data), "output_bom.csv")
```

-   手順1でUTF-8出力、手順2でBOM（\ufeff）を先頭に付与
-   Excelで「output_bom.csv」を開くと正常表示されます。

------------------------------------------------------------------------

## 3. テキストインポートウィザードを使う

Excelを起動し、 *「ファイル」→「開く」→「テキストエンコーダリング：Unicode (UTF-8)」* を選択してCSVを読み込む方法です。 （毎回手動操作が必要になるため、自動化向きではありません）

------------------------------------------------------------------------

### まとめ

-   **最も簡単**：`fileEncoding="UTF-16LE"` で直接出力
-   **UTF-8で手放せない場合**：BOM付与スクリプトを併用
-   **一時的対応**：ExcelのインポートウィザードでUTF-8指定

これらのいずれかを使えば、macOS上のExcelでもスペイン語のアクセント文字が文字化けなく表示されます。

------------------------------------------------------------------------

# macOS版Excelでの文字消失を防ぐ方法

**推奨：** UTF-16LEで一部文字が消える場合は、Excelが標準的に扱える単一バイト文字コード（ISO-8859-1／Latin1 や Windows-1252）での出力、または readr の `write_excel_csv()` を使うのが最も確実です。

------------------------------------------------------------------------

## 1. ISO-8859-1（Latin1）での書き出し

スペイン語のアクセント文字は ISO-8859-1（Latin1）でサポート範囲内なので、これを指定して出力します。

``` r
write.csv(
  df,
  file         = "output_latin1.csv",
  row.names    = FALSE,
  fileEncoding = "ISO-8859-1"
)
```

-   macOS版ExcelはLatin1を問題なく読み込み、特殊文字も消失しません。

------------------------------------------------------------------------

## 2. Windows-1252（CP1252）での書き出し

Windows環境向け文字 （€など）を含む場合は Windows-1252 を指定します。

``` r
write.csv(
  df,
  file         = "output_cp1252.csv",
  row.names    = FALSE,
  fileEncoding = "CP1252"
)
```

-   ISO-8859-1と大半が重複しつつ、一部追加文字もカバーします。

------------------------------------------------------------------------

## 3. readr の write_excel_csv を使う

readr パッケージの `write_excel_csv()` は **BOM付きUTF-8** で出力し、Excelが自動的にUTF-8と認識できるように書き出します。

``` r
library(readr)
write_excel_csv(
  df,
  "output_readr_excel.csv"
)
```

-   UTF-8での出力を維持しつつ、BOMを先頭に付与
-   macOS／WindowsいずれのExcelでも文字化けが生じにくい

------------------------------------------------------------------------

## 4. xlsx 形式で直接書き出す

CSVではなくXLSXファイルを生成する方法です。`openxlsx` パッケージ等を使えば、文字コード問題を回避できます。

``` r
library(openxlsx)
write.xlsx(
  df,
  file = "output.xlsx",
  overwrite = TRUE
)
```

-   Excelネイティブ形式のため文字化けが起こりません

------------------------------------------------------------------------

これらの方法のいずれかを利用すれば、macOS版Excelでスペイン語のアクセント文字が消失したり文字化けしたりする問題を回避できます。
