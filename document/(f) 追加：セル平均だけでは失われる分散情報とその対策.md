<img src="https://r2cdn.perplexity.ai/pplx-full-logo-primary-dark%402x.png" style="height:64px;margin-right:32px"/>

# 1. 元データで各セルの平均・SD・SE・四分位数を再計算。

2.  マージ用テーブルに平均とともにSD（またはSE, Q1, Q3）を追加。
3.  マージ先データで、セル識別子を固定効果／ランダム効

この手順に関する参考文献はありますか

地域×年次×所得区分のような**セル（集計単位）ごとの平均値を他データにマージし、モデル化する手法**は、統計学的には「集計データの階層モデリング（multilevel modeling with aggregate-level covariates）」や「エコロジカル推論（ecological inference）」の一部として扱われます。以下の文献が、提示された手順（平均・分散の算出、セル識別子を活用した固定効果／ランダム効果の導入、不確実性の伝播と評価）を理論的に裏付けています。

------------------------------------------------------------------------

## 主要な参考文献

### 1. Goldstein, H. (2011). *Multilevel Models*. University of Bristol / Centre for Multilevel Modelling.

多層データ（例：地域・世帯）の平均と分散を同時にモデル化する方法を体系的に解説。セル識別子を固定効果またはランダム効果として導入する原理的背景を提示。[^セルへいきん：参考文献-1]

[^セルへいきん：参考文献-1]: <https://www.bristol.ac.uk/media-library/sites/cmm/migrated/documents/introduction-to-multilevel-models.pdf>

### 2. Draper, D. (1995). *Assessment and Propagation of Model Uncertainty*. *Journal of the Royal Statistical Society: Series B*, 57(1), 45–97.

推定量の標準誤差や集計段階の不確実性（SE, SD）を次段階モデルに伝播する考え方の基礎文献。ベイズ的アプローチによる不確実性の統合手法を提示。[^セルへいきん：参考文献-2]

[^セルへいきん：参考文献-2]: <https://academic.oup.com/jrsssb/article/57/1/45/7035874>

### 3. Gelfand, A. E. (2012). *Hierarchical Modeling for Spatial Data Problems*. *Journal of Statistical Planning and Inference*.

地域区分など地理的セルの平均値とばらつきを階層モデル内で扱う具体例。空間的依存を考慮した消費・環境などの集計データ分析に適用可能。[^セルへいきん：参考文献-3]

[^セルへいきん：参考文献-3]: <https://pmc.ncbi.nlm.nih.gov/articles/PMC3760588/>

### 4. King, G. (1999). *Ecological Inference*. *Proceedings of the National Academy of Sciences*, 96(19), 10578–10579.

集計データを個票レベル推論に結びつける際の理論的課題（エコロジカル・フォールシー）を解説。平均値のみをセル代表値とすることの限界と調整法を議論。[^セルへいきん：参考文献-4]

[^セルへいきん：参考文献-4]: <https://www.pnas.org/doi/10.1073/pnas.96.19.10578>

### 5. Li, Q. (2025). *Assessing and Adjusting for Bias in Ecological Analysis*. *Frontiers in Population Health*, 2025年4月発行。

集計平均を個体データにマージする際のバイアス評価手法を近年の動向として整理。誤差構造・ランダム効果導入・不確実性補正を対象とする最新の実証研究。[^セルへいきん：参考文献-5]

[^セルへいきん：参考文献-5]: <https://pmc.ncbi.nlm.nih.gov/articles/PMC12023363/>

### 6. Lee, C. J. (2025). *A Scalable Two-Stage Bayesian Approach Accounting for Measurement Error and Uncertainty Propagation*. *Biostatistics*, 26(1).

第1段階モデル（例：平均消費量算出）から第2段階モデル（健康や所得のモデル）への**不確実性の伝播（二段階ベイズモデル）**を提案。今回のようなマージ構造に極めて近い。[^セルへいきん：参考文献-6]

[^セルへいきん：参考文献-6]: <https://academic.oup.com/biostatistics/article/26/1/kxae038/7811180>

------------------------------------------------------------------------

## 推奨読書の位置づけ

| 方法論テーマ | 参考文献 | 主要内容 |
|:---|:---|:---|
| 階層モデル・集計平均の統合 | Goldstein (2011) | セル内ばらつきの階層的モデル化方法 |
| 不確実性伝播 | Draper (1995), Lee (2025) | SEを2段階モデルに反映するベイズ的フレームワーク |
| 地理的／集計単位の構造 | Gelfand (2012) | 地域別平均値＋空間的階層モデリング |
| 集計データと平均値マージの理論的限界 | King (1999), Li (2025) | エコロジカル推論とバイアス補正の原理 |

------------------------------------------------------------------------

**要点** 地域×年×所得層セルの平均とばらつきをマージして用いる際には、

1.  Goldstein (2011) および Draper (1995) に基づく**階層／二段階モデル構築**、
2.  King (1999) と Li (2025) による**エコロジカル推論の注意点と補正法** を踏まえてモデルを設計すると、理論的に一貫した方法でばらつき情報を保持しつつ、推定の信頼性を確保できます。 [^セルへいきん：参考文献-7],[^セルへいきん：参考文献-8],[^セルへいきん：参考文献-9],[^セルへいきん：参考文献-10],[^セルへいきん：参考文献-11],[^セルへいきん：参考文献-12],[^セルへいきん：参考文献-13],[^セルへいきん：参考文献-14],[^セルへいきん：参考文献-15],[^セルへいきん：参考文献-16],[^セルへいきん：参考文献-17],[^セルへいきん：参考文献-18],[^セルへいきん：参考文献-19],[^セルへいきん：参考文献-20]

[^セルへいきん：参考文献-7]: [<https://pmc.ncbi.nlm.nih.gov/articles/PMC7811229/>]{style="display:none"}

[^セルへいきん：参考文献-8]: <https://gking.harvard.edu/files/eiintro.pdf>

[^セルへいきん：参考文献-9]: [https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1417\\&context=psychfacpub](https://digitalcommons.unl.edu/cgi/viewcontent.cgi?article=1417\&context=psychfacpub){.uri}

[^セルへいきん：参考文献-10]: <https://sites.stat.columbia.edu/gelman/research/unpublished/extrap_paper.pdf>

[^セルへいきん：参考文献-11]: <https://besjournals.onlinelibrary.wiley.com/doi/full/10.1111/2041-210X.14505>

[^セルへいきん：参考文献-12]: <https://www.sciencedirect.com/science/article/pii/S2665945X21000206>

[^セルへいきん：参考文献-13]: <https://www.sciencedirect.com/topics/social-sciences/ecological-inference>

[^セルへいきん：参考文献-14]: <https://discourse.mc-stan.org/t/multilevel-modelling-questions-about-model-design/4100>

[^セルへいきん：参考文献-15]: <https://pubmed.ncbi.nlm.nih.gov/10485866/>

[^セルへいきん：参考文献-16]: <https://discourse.datamethods.org/t/what-would-be-the-most-truthful-way-to-draw-inferences-in-a-multilevel-cell-biology-dataset/4979>

[^セルへいきん：参考文献-17]: <https://gking.harvard.edu/files/gking/files/ecinf04.pdf>

[^セルへいきん：参考文献-18]: <https://www.sciencedirect.com/science/article/pii/S1364815220309622>

[^セルへいきん：参考文献-19]: <https://www.sciencedirect.com/science/article/abs/pii/S0951832021006876>

[^セルへいきん：参考文献-20]: <https://journals.plos.org/plosone/article?id=10.1371%2Fjournal.pone.0025635>

::: {align="center"}
⁂
:::
