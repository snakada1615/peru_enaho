library(dplyr)
library(haven)


diagnose_year <- function(year_current) {
  df_mod7 <- open_enaho_file(year_current, "mod7") %>%
    mutate(year = as.numeric(year_current))
  
  cat("=== Year:", year_current, "===\n")
  cat("names(df_mod7) contains P601A? ", "P601A" %in% names(df_mod7), "\n")
  if(!("P601A" %in% names(df_mod7))) return(invisible(NULL))
  
  # basic structure
  print(str(df_mod7$P601A))
  
  # raw head
  cat("head raw P601A:\n"); print(head(df_mod7$P601A, 10))
  
  # zap_labels result
  lab_vals <- tryCatch(haven::zap_labels(df_mod7$P601A), error = function(e) e)
  cat("class(zap_labels(...)):", if(inherits(lab_vals, "error")) "ERROR" else class(lab_vals), "\n")
  if(inherits(lab_vals, "error")) { print(lab_vals); return(invisible(NULL)) }
  cat("head zap_labels:\n"); print(head(lab_vals, 10))
  
  num_vals <- as.numeric(lab_vals)
  cat("head as.numeric(zap_labels):\n"); print(head(num_vals, 10))
  cat("sum NA after as.numeric:", sum(is.na(num_vals)), " / ", length(num_vals), "\n")
  cat("unique count (small sample):", length(unique(num_vals)), "\n")
  cat("range (na.rm=TRUE):", range(num_vals, na.rm = TRUE), "\n")
  
  # check against df_food_grp
  cat("df_food_grp code_food sample and class:\n"); print(head(df_food_grp$code_food, 10)); print(class(df_food_grp$code_food))
  
  # unmatched codes
  df_codes_mod7 <- tibble(P601A_num = unique(num_vals))
  unmatched <- df_codes_mod7 %>%
    filter(!is.na(P601A_num)) %>%
    anti_join(tibble(code_food = unique(df_food_grp$code_food)), by = c("P601A_num" = "code_food"))
  cat("Number of unique codes in mod7:", nrow(df_codes_mod7), "\n")
  cat("Number of unmatched codes vs df_food_grp:", nrow(unmatched), "\n")
  if(nrow(unmatched) > 0) {
    cat("Some unmatched sample values:\n"); print(head(unmatched, 20))
  }
  
  invisible(list(num_vals = num_vals, unmatched = unmatched))
}

diagnose_year("2011")
