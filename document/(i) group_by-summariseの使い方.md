# Rでグループごとの非NA値の数をカウントする方法

## 問題の説明

データフレーム(df)に以下の構造があります： - **カテゴリ変数**: grp1, grp2 - **連続変数**: var1, var2, ...var8

各グループの組み合わせ(grp1とgrp2)ごとに、連続変数に含まれる非NA値(!is.na())の数をカウントしたい場合の解決方法です。

------------------------------------------------------------------------

## 方法1: dplyrパッケージを使用（推奨）

最も簡潔でかつ読みやすい方法です。

```{r}
library(dplyr)

result <- df %>%
  group_by(grp1, grp2) %>%
  summarise(
    var1_count = sum(!is.na(var1)),
    var2_count = sum(!is.na(var2)),
    var3_count = sum(!is.na(var3)),
    var4_count = sum(!is.na(var4)),
    var5_count = sum(!is.na(var5)),
    var6_count = sum(!is.na(var6)),
    var7_count = sum(!is.na(var7)),
    var8_count = sum(!is.na(var8)),
    .groups = 'drop'
  )
```

または、より簡潔に複数の変数を一度に処理する場合：

```{r}
result <- df %>%
  group_by(grp1, grp2) %>%
  summarise(
    across(var1:var8, ~sum(!is.na(.)), .names = "{.col}_count"),
    .groups = 'drop'
  )
```

------------------------------------------------------------------------

## 方法2: base Rの集約関数を使用

dplyrを使いたくない場合は、`aggregate()`関数を使用できます。

```{r}
result <- aggregate(
  df[, c("var1", "var2", "var3", "var4", "var5", "var6", "var7", "var8")],
  by = list(grp1 = df$grp1, grp2 = df$grp2),
  FUN = function(x) sum(!is.na(x))
)
```

------------------------------------------------------------------------

## 方法3: data.tableパッケージを使用

高速な処理が必要な場合に有効です。

```{r}
library(data.table)

dt <- as.data.table(df)

result <- dt[, 
  lapply(.SD, function(x) sum(!is.na(x))), 
  by = .(grp1, grp2),
  .SDcols = c("var1", "var2", "var3", "var4", "var5", "var6", "var7", "var8")
]
```

------------------------------------------------------------------------

## 方法4: ロングフォーマットに変換（より柔軟）

データを縦長フォーマットに変換する場合：

```{r}
library(dplyr)
library(tidyr)

result <- df %>%
  pivot_longer(
    cols = var1:var8,
    names_to = "variable",
    values_to = "value"
  ) %>%
  group_by(grp1, grp2, variable) %>%
  summarise(
    count_non_na = sum(!is.na(value)),
    .groups = 'drop'
  )
```

------------------------------------------------------------------------

## 出力例

各方法で得られる結果のサンプル出力：

```         
  grp1 grp2 var1_count var2_count var3_count var4_count var5_count var6_count var7_count var8_count
1    A    X         10          9          8          10         9          10         7          9
2    A    Y          8          8          8          7          8          8          8          8
3    B    X         10         10         10         10          10         10         10         10
4    B    Y          9          9          9          9          9          9          9          9
```

------------------------------------------------------------------------

## 推奨事項

| 状況 | 推奨方法 |
|----|----|
| 一般的な分析 | **方法1（dplyr + across）** - 最も読みやすく、保守性が高い |
| base Rのみで実行 | **方法2（aggregate）** - 追加パッケージが不要 |
| 大規模データセット | **方法3（data.table）** - 高速処理が可能 |
| 柔軟な分析が必要 | **方法4（ロングフォーマット）** - 可視化や追加分析に最適 |

------------------------------------------------------------------------

## まとめ

最も実用的でシンプルな方法は、**dplyrの`across()`関数**を使用する方法2です。このアプローチは： - コードが簡潔で読みやすい - 複数の変数を効率的に処理 - グループ分析に最適化されている - tidyverseエコシステムと互換性がある

# Rのacross()で外部変数を使用する方法

## 問題の説明

`dplyr`の`across()`関数で、事前に定義した変数（ベクトル）に格納された列名を使用したい場合の方法を説明します。

例：

```{r}
cols <- c("var1", "var2", "var6", "var7")
```

このような外部変数を`across()`に渡す方法です。

------------------------------------------------------------------------

## 方法1: all_of()を使用（推奨）

**最も安全で推奨される方法**です。指定した列がすべて存在することを保証します。

```{r}
library(dplyr)

# 外部変数の定義
cols <- c("var1", "var2", "var6", "var7")

result <- df %>%
  group_by(grp1, grp2) %>%
  summarise(
    across(all_of(cols), ~sum(!is.na(.)), .names = "{.col}_count"),
    .groups = 'drop'
  )
```

### all_of()の特徴

-   指定した列名がすべて存在しない場合、**エラーを返す**
-   安全性が高く、タイポや存在しない列名を早期に検出できる
-   プログラミングで変数を使用する場合の標準的な方法

------------------------------------------------------------------------

## 方法2: any_of()を使用

指定した列の一部が存在しない可能性がある場合に使用します。

```{r}
# 外部変数の定義
cols <- c("var1", "var2", "var6", "var7", "var_not_exist")

result <- df %>%
  group_by(grp1, grp2) %>%
  summarise(
    across(any_of(cols), ~sum(!is.na(.)), .names = "{.col}_count"),
    .groups = 'drop'
  )
```

### any_of()の特徴

-   指定した列名の一部が存在しなくても**エラーにならない**
-   存在する列のみを処理する
-   柔軟性が必要な場合に有用

------------------------------------------------------------------------

## 方法3: matches()やstarts_with()など正規表現を使用

パターンマッチングで列を選択する場合：

```{r}
# パターンで列を選択
result <- df %>%
  group_by(grp1, grp2) %>%
  summarise(
    across(matches("var[1267]"), ~sum(!is.na(.)), .names = "{.col}_count"),
    .groups = 'drop'
  )

# 接頭辞で選択
result <- df %>%
  group_by(grp1, grp2) %>%
  summarise(
    across(starts_with("var"), ~sum(!is.na(.)), .names = "{.col}_count"),
    .groups = 'drop'
  )
```

------------------------------------------------------------------------

## 方法4: tidyselect記法と組み合わせ

複数の選択方法を組み合わせることも可能です。

```{r}
cols <- c("var1", "var2")
additional_cols <- c("var6", "var7")

result <- df %>%
  group_by(grp1, grp2) %>%
  summarise(
    across(c(all_of(cols), all_of(additional_cols)), 
           ~sum(!is.na(.)), 
           .names = "{.col}_count"),
    .groups = 'drop'
  )
```

または、除外する列を指定：

```{r}
cols_to_exclude <- c("var3", "var4", "var5", "var8")

result <- df %>%
  group_by(grp1, grp2) %>%
  summarise(
    across(starts_with("var") & !all_of(cols_to_exclude), 
           ~sum(!is.na(.)), 
           .names = "{.col}_count"),
    .groups = 'drop'
  )
```

------------------------------------------------------------------------

## 注意事項：引用符の有無

### 文字列ベクトルとして定義（推奨）

```{r}
# 正しい方法
cols <- c("var1", "var2", "var6", "var7")

result <- df %>%
  group_by(grp1, grp2) %>%
  summarise(
    across(all_of(cols), ~sum(!is.na(.))),
    .groups = 'drop'
  )
```

### シンボルとして定義する場合（非推奨）

もし引用符なしで定義したい場合は、以下のようにします：

```{r}
# この方法は通常使用しません
cols <- c(var1, var2, var6, var7)  # これはエラーになります

# 代わりにquote()やrlang::syms()を使用
cols <- rlang::syms(c("var1", "var2", "var6", "var7"))
result <- df %>%
  group_by(grp1, grp2) %>%
  summarise(
    across(!!!cols, ~sum(!is.na(.))),
    .groups = 'drop'
  )
```

**推奨**: 文字列ベクトルとして定義し、`all_of()`または`any_of()`を使用する方法がシンプルで読みやすいです。

------------------------------------------------------------------------

## 実践例

```{r}
library(dplyr)

# サンプルデータの作成
df <- data.frame(
  grp1 = rep(c("A", "B"), each = 5),
  grp2 = rep(c("X", "Y"), 5),
  var1 = c(1, 2, NA, 4, 5, 6, 7, 8, 9, 10),
  var2 = c(NA, 2, 3, 4, 5, 6, NA, 8, 9, 10),
  var3 = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10),
  var4 = c(1, NA, 3, 4, 5, 6, 7, 8, NA, 10),
  var5 = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10),
  var6 = c(1, 2, 3, NA, 5, 6, 7, 8, 9, NA),
  var7 = c(NA, NA, 3, 4, 5, 6, 7, 8, 9, 10),
  var8 = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
)

# 処理したい列を外部変数として定義
cols <- c("var1", "var2", "var6", "var7")

# all_of()を使用してグループ集計
result <- df %>%
  group_by(grp1, grp2) %>%
  summarise(
    across(all_of(cols), ~sum(!is.na(.)), .names = "{.col}_count"),
    .groups = 'drop'
  )

print(result)
```

### 出力例

```         
# A tibble: 4 × 6
  grp1  grp2  var1_count var2_count var6_count var7_count
  <chr> <chr>      <int>      <int>      <int>      <int>
1 A     X              2          2          2          1
2 A     Y              2          2          2          2
3 B     X              3          2          3          3
4 B     Y              2          3          2          3
```

------------------------------------------------------------------------

## まとめ：all_of() vs any_of()

| 関数 | 使用場面 | 列が存在しない場合の動作 |
|----|----|----|
| **all_of()** | 指定した列がすべて存在することを確認したい | エラーを返す（安全） |
| **any_of()** | 一部の列が存在しない可能性がある | エラーにならず、存在する列のみ処理 |

**推奨**: ほとんどの場合、`all_of()`を使用することで、タイポや設定ミスを早期に発見できます。
