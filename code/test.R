library(dplyr)
library(haven)

# unmatched を列挙
codes_mod7 <- sort(unique(df_mod7$P601A_num))
codes_foodgrp <- sort(unique(df_food_grp$code_food))
unmatched <- setdiff(codes_mod7, codes_foodgrp)

length(unmatched)        # 何個か
unmatched                # 候補一覧

# 頻度（どれが頻繁に現れるか）
df_mod7 %>%
  filter(P601A_num %in% unmatched) %>%
  count(P601A_num, sort = TRUE) -> unmatched_freq
unmatched_freq

# 未マッチコードと元のラベル（文字列表示）
df_mod7 %>%
  filter(P601A_num %in% unmatched) %>%
  distinct(P601A_num, P601A_label = haven::zap_labels(P601A)) %>%
  arrange(P601A_num) -> unmatched_labels
unmatched_labels