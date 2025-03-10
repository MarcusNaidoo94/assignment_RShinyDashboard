# Load  libraries
library(dplyr)
library(ggplot2)
library(tidyr)
library(stringr)
library(plotly)
library(forcats)

# Define a dark theme for plots
dark_theme <- theme(
  panel.background = element_rect(fill = "#2D2D2D", color = NA),  # Slightly lighter dark background
  plot.background = element_rect(fill = "#2D2D2D", color = NA),  # Lighter dark plot area
  panel.grid.major = element_line(color = "#555555"),  # Slightly more visible gridlines
  panel.grid.minor = element_line(color = "#444444"),  # Subtle minor gridlines
  axis.text = element_text(color = "#EAEAEA"),  # Light-colored axis labels
  axis.title = element_text(color = "#FFFFFF"),  # White axis titles
  plot.title = element_text(color = "#FFFFFF", 
                            size = 14, 
                            face = "bold"),  # Title styling
  legend.background = element_rect(fill = "#2D2D2D"),  # Dark background
  legend.text = element_text(color = "#EAEAEA"),  # Light text in legend
  legend.title = element_text(color = "#FFFFFF")  # White legend title
)

# Function to get top tools used by graduates
get_top_tools <- function(df, column_name, top_n = 10) {
  df %>% 
    select(all_of(column_name)) %>% 
    filter(!!sym(column_name) != "Unknown") %>% 
    mutate(!!sym(column_name) := strsplit(!!sym(column_name), ";")) %>% 
    unnest(cols = all_of(column_name)) %>% 
    count(!!sym(column_name), sort = TRUE) %>% 
    slice_head(n = top_n)
}

# Function to visualize top tech tools
visualize_top_tech_tools <- function(df, study_field, column_name) {
  df_filtered <- df %>% filter(StudyField == study_field)
  top_tools <- get_top_tools(df_filtered, 
                             column_name)
  
  p <- ggplot(top_tools, aes(x = fct_reorder(!!sym(column_name), n), 
                             y = n, 
                             fill = !!sym(column_name))) + 
    geom_col(show.legend = FALSE) + 
    coord_flip() + 
    labs(title = paste("Top", column_name, "Used by Graduates"),
         x = column_name, y = "Number of Users") + 
    dark_theme
  
  return(ggplotly(p))  # Return plotly plot
}

# Function to visualize industry distribution
visualize_industry_distribution <- function(df, study_field) {
  industry_counts <- df %>% 
    filter(StudyField == study_field) %>% 
    select(Industry) %>% 
    filter(Industry != "Unknown") %>% 
    mutate(Industry = strsplit(Industry, ";")) %>% 
    unnest(cols = Industry) %>% 
    count(Industry, sort = TRUE)
  
  p <- ggplot(industry_counts, aes(x = fct_reorder
                                   (Industry, n), 
                                   y = n, 
                                   fill = Industry)) + 
    geom_col(show.legend = FALSE) + 
    coord_flip() + 
    labs(title = "Industry Distribution by Study Field", x = "Industry", y = "Count") + 
    dark_theme
  
  return(ggplotly(p))
}

# Function to visualize the employment rate summary
visualize_employment_rate <- function(df) {
  # Ensure Employment column exists
  if (!"Employment" %in% colnames(df)) {
    return(NULL)  # Return NULL if Employment column is missing
  }
  
  # Clean Employment data
  df_filtered <- df %>%
    mutate(EmploymentStatus = case_when(
      grepl("Employed", Employment, ignore.case = TRUE) ~ "Employed",
      grepl("Not employed", Employment, ignore.case = TRUE) ~ "Not Employed",
      TRUE ~ "Other"
    )) %>%
    filter(EmploymentStatus %in% c("Employed", "Not Employed")) %>%
    group_by(StudyField, EmploymentStatus) %>%
    summarise(Count = n(), .groups = "drop") %>%
    mutate(TotalGraduates = sum(Count)) %>%
    mutate(EmploymentRate = round((Count / TotalGraduates) * 100, 2))
  
  # Check if data is empty
  if (nrow(df_filtered) == 0) {
    return(NULL)  # Prevent errors if no data
  }
  
  # Generate Plotly Bar Chart
  p <- ggplot(df_filtered, aes(x = StudyField, y = EmploymentRate, fill = EmploymentStatus)) +
    geom_col(position = "dodge") +
    labs(title = "Employment Rate of Graduates", 
         x = "Study Field", 
         y = "Employment Rate (%)",
         fill = "Employment Status") +
    dark_theme
  
  return(ggplotly(p))  # Ensure returning a valid Plotly object
}

