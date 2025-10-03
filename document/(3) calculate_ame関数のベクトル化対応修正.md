<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" style="height:64px;margin-right:32px"/>

# dfの要素の値を使って、新しい要素を作成する（関数のベクトル対応）

エラーの原因は、`calculate_ame`関数が単一の値を想定しているのに対し、`mutate()`内でベクトル全体が渡されることです。以下の修正方法を提案します。

## **方法1: ベクトル化対応の関数に書き換え（推奨）**

``` r
calculate_ame_vectorized <- function(age_vec, sex_vec) {
  # 結果を格納するベクトルを初期化
  result <- numeric(length(age_vec))
  
  # 各ユニークな組み合わせに対して処理
  for(i in seq_along(age_vec)) {
    if(!is.na(age_vec[i]) && !is.na(sex_vec[i])) {
      matched_row <- df_AME %>%
        filter(age_min < age_vec[i] & age_max >= age_vec[i] & sex == sex_vec[i])
      
      if(nrow(matched_row) > 0) {
        result[i] <- matched_row$AME[1]
      } else {
        result[i] <- NA  # マッチしない場合
      }
    } else {
      result[i] <- NA  # NAの場合
    }
  }
  
  return(result)
}
```

## **方法2: dplyrの効率的な結合を使用（最も効率的）**

``` r
# df_mod4を修正する際に以下を使用
df_mod4 <- df_mod4 %>%
  mutate(
    P400A2 = ifelse(is.na(P400A2), "6", P400A2),
    P400A3 = ifelse(is.na(P400A3), "1990", P400A3)
  ) %>%
  mutate(
    age = calculate_age_vectorized(as.numeric(P400A3), as.numeric(P400A2), 
                        as.numeric(AÑO), as.numeric(MES)),
    sex_char = ifelse(P207 == 1, "male", "female")
  ) %>%
  # 効率的な結合を使用
  left_join(
    df_AME %>% select(age_min, age_max, sex, AME),
    by = "sex",
    relationship = "many-to-many"
  ) %>%
  filter(age_min < age & age_max >= age) %>%
  group_by(row_number()) %>%
  slice(1) %>%  # 最初のマッチを選択
  ungroup() %>%
  rename(adult_male_equivalent = AME) %>%
  select(-age_min, -age_max, -sex_char)
```

## **方法3: mapply()を使用（シンプルな修正）**

``` r
# 既存の関数をそのまま使用
df_mod4 <- df_mod4 %>%
  mutate(
    P400A2 = ifelse(is.na(P400A2), "6", P400A2),
    P400A3 = ifelse(is.na(P400A3), "1990", P400A3)
  ) %>%
  mutate(
    age = calculate_age_vectorized(as.numeric(P400A3), as.numeric(P400A2), 
                        as.numeric(AÑO), as.numeric(MES))
  ) %>%
  mutate(
    adult_male_equivalent = mapply(calculate_ame, 
                                  age, 
                                  ifelse(P207 == 1, "male", "female"))
  )
```

## **方法4: rowwise()を使用**

``` r
df_mod4 <- df_mod4 %>%
  mutate(
    P400A2 = ifelse(is.na(P400A2), "6", P400A2),
    P400A3 = ifelse(is.na(P400A3), "1990", P400A3)
  ) %>%
  mutate(
    age = calculate_age_vectorized(as.numeric(P400A3), as.numeric(P400A2), 
                        as.numeric(AÑO), as.numeric(MES))
  ) %>%
  rowwise() %>%
  mutate(
    adult_male_equivalent = calculate_ame(age, ifelse(P207 == 1, "male", "female"))
  ) %>%
  ungroup()
```

## **推奨事項**

**大規模データの場合**: **方法2（left_join使用）**が最も効率的です。

**シンプルな修正の場合**: **方法3（mapply使用）**が既存コードの変更が最小限で済みます。

**データサイズが小さい場合**: **方法1（ベクトル化関数）**が最も理解しやすいです。

**方法3のmapply()使用**が最もシンプルな修正方法として推奨します。

------------------------------------------------------------------------

# left_join()の構文修正

エラーの原因は`left_join()`の`by`引数の構文が間違っていることです。以下の修正版を提案します。

## **修正版1: 正しいleft_join構文**

``` r
df_mod4 <- df_mod4 %>%
  mutate(
    P400A2 = ifelse(is.na(P400A2), "6", P400A2),
    P400A3 = ifelse(is.na(P400A3), "1990", P400A3)
  ) %>%
  mutate(
    age = calculate_age_vectorized(as.numeric(P400A3), as.numeric(P400A2), 
                        as.numeric(AÑO), as.numeric(MES)),
    sex_char = ifelse(P207 == 1, "male", "female")
  ) %>%
  # 正しい結合構文
  left_join(
    df_AME %>% select(age_min, age_max, sex, AEQ),
    by = c("sex_char" = "sex"),  # 正しい構文
    relationship = "many-to-many"
  ) %>%
  filter(age_min < age & age_max >= age) %>%
  group_by(row_number()) %>%
  slice(1) %>%
  ungroup() %>%
  rename(adult_male_equivalent = AEQ) %>%
  select(-age_min, -age_max, -sex_char)
```

## **修正版2: より安全なアプローチ**

``` r
df_mod4 <- df_mod4 %>%
  mutate(
    P400A2 = ifelse(is.na(P400A2), "6", P400A2),
    P400A3 = ifelse(is.na(P400A3), "1990", P400A3)
  ) %>%
  mutate(
    age = calculate_age_vectorized(as.numeric(P400A3), as.numeric(P400A2), 
                        as.numeric(AÑO), as.numeric(MES)),
    sex_char = ifelse(P207 == 1, "male", "female")
  ) %>%
  # 一時的にrow_idを追加
  mutate(temp_row_id = row_number()) %>%
  # 結合
  left_join(
    df_AME %>% 
      select(age_min, age_max, sex, AEQ) %>%
      mutate(age_min = as.numeric(age_min),
             age_max = as.numeric(age_max)),
    by = c("sex_char" = "sex"),
    relationship = "many-to-many"
  ) %>%
  # 年齢範囲でフィルタリング
  filter(age >= age_min & age < age_max) %>%
  # 各元の行に対して最初のマッチを選択
  group_by(temp_row_id) %>%
  slice(1) %>%
  ungroup() %>%
  rename(adult_male_equivalent = AEQ) %>%
  select(-age_min, -age_max, -sex_char, -temp_row_id)
```

## **修正版3: mapplyを使用した確実な方法**

``` r
df_mod4 <- df_mod4 %>%
  mutate(
    P400A2 = ifelse(is.na(P400A2), "6", P400A2),
    P400A3 = ifelse(is.na(P400A3), "1990", P400A3)
  ) %>%
  mutate(
    age = calculate_age_vectorized(as.numeric(P400A3), as.numeric(P400A2), 
                        as.numeric(AÑO), as.numeric(MES)),
    sex_char = ifelse(P207 == 1, "male", "female")
  ) %>%
  mutate(
    adult_male_equivalent = mapply(calculate_ame, 
                                  age, 
                                  sex_char,
                                  USE.NAMES = FALSE)
  ) %>%
  select(-sex_char)
```

## **主な修正点**

1.  **by引数の修正**: `by = "sex_char == sex"` → `by = c("sex_char" = "sex")`
2.  **列名の確認**: `AEQ`列が正しいか確認（元は`AME`でした）
3.  **数値型変換**: `age_min`, `age_max`の型確認
4.  **フィルタ条件**: `age >= age_min & age < age_max`に統一

## **推奨事項**

**修正版3（mapply使用）**が最も確実で理解しやすい方法です。既存の`calculate_ame`関数をそのまま使用でき、エラーが起きにくいです。

大規模データでパフォーマンスが重要な場合は**修正版2**を使用してください。
