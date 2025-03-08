# Import libraries
library(dplyr)
library(readr)
library(tidyr)

# Define a function to clean and return dataset
get_cleaned_data <- function(df) {
  # 1a: Pick appropriate columns
  relevant_columns <- c("Campus",
                        "StudyField",
                        "Branch",
                        "Role",
                        "EduLevel",
                        "ProgLang", 
                        "Databases",
                        "Platform",
                        "WebFramework",
                        "Industry",
                        "AISearch",
                        "AITool",
                        "Employment")
  df_selected <- df %>% select(all_of(relevant_columns))
  
  # 1b: Clean the data based on defined assumptions
  df_cleaned <- df_selected %>%
    mutate(across(everything(), ~ replace_na(.x, "Unknown")))
  
  # 1c: Clean campus names
  df_cleaned <- df_cleaned %>%
    mutate(Campus = case_when(
      Campus %in% c("Durban", "Umhlanga") ~ "Durban",
      Campus %in% c("Port Elizabeth", "Gqeberha") ~ "Gqeberha",
      TRUE ~ Campus
    ))
  
  # 1d: Get the top 5 campuses
  top_campuses <- df_cleaned %>%
    count(Campus, sort = TRUE) %>%
    slice_head(n = 5) %>%
    pull(Campus)
  
  df_final <- df_cleaned %>%
    filter(Campus %in% top_campuses)
  
  # Store cleaned dataset into a variable instead of printing
  return(df_final)
}

