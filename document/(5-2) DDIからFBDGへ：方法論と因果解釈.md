<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" style="height:64px;margin-right:32px"/>

# DDIからFBDGへ：方法論と因果解釈

### 1. 所得効果と食事要因の識別

-   **問題点**\
    地域×所得区分でENAHO平均摂取量をENDESに適用すると、変数は所得階層による差異を強く含むため、純粋な食事経路の因果効果とは言い難い。\
-   **解決策**\
    所得経路と食事経路を分離する操作変数法（IV/2SLS）を導入。

------------------------------------------------------------------------

### 2. 操作変数としてのJUNTOS受給率

1.  **受給率作成（ENAHO）**\

```{r}

library(dplyr) enaho_rate <- enaho %>% 
  mutate(juntos_flag = (p626==1 & p627=="Juntos")) %>% 
  group_by(region, wealth_decile, year) %>% 
  summarize( 
    juntos_rate = mean(juntos_flag, na.rm=TRUE), 
    cereal_share = mean(energy_cereal/total_energy, na.rm=TRUE), 
    legume_share = mean(energy_legume/total_energy, na.rm=TRUE), 
    veg_share = mean(energy_veg/total_energy, na.rm=TRUE) 
    )
```

2.  **ENDESデータに結合**\

```{r}

edes_linked <- edes %>% 
  left_join(enaho_rate, 
            by=c("region","wealth_decile","year")
            )
```

------------------------------------------------------------------------

### 3. 2段階LASSOモデルでの実装例

1)  **第一段階：食品群シェアの予測**\

```{r}

library(glmnet)

# 操作変数と共変量で穀物シェア予測

X1 <- model.matrix(~ juntos_rate + child_age + child_sex + mother_edu, data=edes_linked) 
y1 <- edes_linked$cereal_share
fit1 <- cv.glmnet(X1, y1, alpha=1)
   edes_linked$pred_cereal <- predict(fit1, X1, s="lambda.min")
   
```

2)  **第二段階：Stuntingへの効果推定**\

```{r}

# 予測シェアと共変量でStunting予測

X2 <- model.matrix(~ pred_cereal + pred_legume + pred_veg + child_age + 
                     child_sex + mother_edu, data=edes_linked) 
y2 <- edes_linked$stunting 
fit2 <- cv.glmnet(X2, y2, family="binomial", alpha=1)

coef(fit2, s="lambda.min")
```

-   **ポイント**\
-   操作変数 `juntos_rate` は第一段階のみ使用\
-   第二段階には外生化された `pred_*` シェアを投入\
-   必要に応じて他食品群も同様に予測し、多変量モデルに含める

------------------------------------------------------------------------

## 結論

1.  単純な地域×所得平均モデルでは、所得効果を剥がせない\
2.  JUNTOS操作変数を用いたIV/2段階LASSOで、**純粋な食事摂取量経路の因果効果**を抽出可能\
3.  連続的な食品群シェア変数により、量的寄与度を評価しやすくなる
