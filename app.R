# Import  libraries
library(shiny)
library(shinythemes)  # For UI themes
library(bslib)  # For bootstrap css
library(ggplot2)
library(dplyr)
library(plotly)
library(DT)
library(readr)

# load dataset
file_path <- "cleaned_graduate_survey.csv"
df <- read_csv(file_path, col_types = cols(.default = "c"))

# Load scripts containing questions
source("data/Question1.R")
source("data/Question2.R")

# Define UI Theme (Bootstrap 5)
theme_custom <- bs_theme(
  bootswatch = "superhero",  # 
  base_font = font_google("Roboto"),  # font
  primary = "#3A3F44", # dark gray
  success = "#27AE60", # 
  bg = "#2B2B2B",  # For dark background
  fg = "#DADADA"  # Off white text 
)



# UI Layout
ui <- fluidPage(
  theme = theme_custom,  #  theme
  titlePanel("🎓 Eduvos IT Graduates - Survey Dashboard"),
  
  # Force horizontal scrolling using CSS
  tags$head(
    tags$style(HTML("
      .dataTables_wrapper {
        width: 100%; 
        overflow-x: auto; 
      }
      table.dataTable {
        width: 100%;
        white-space: nowrap;
      }
    "))
  ),
  
  sidebarLayout(
    sidebarPanel(
      h4("🔍 Filter Data"),  # Add a label 
      selectInput("study_field", "Select Study Field:", 
                  choices = unique(df$StudyField), 
                  selected = unique(df$StudyField)[1]),
      selectInput("tech_category", "Select Tech Category:", 
                  choices = c("Programming Languages" = "ProgLang",
                              "Databases" = "Databases",
                              "Web Frameworks" = "WebFramework",
                              "Platforms" = "Platform",
                              "AI Tools" = "AITool",
                              "AI Search Tools" = "AISearch"),
                  selected = "ProgLang"),
      hr(),
      p("📊 Explore insights about graduates' career paths."),
      br()
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("📋 Cleaned Data", 
                 div(style = "overflow-x: auto;", 
                     dataTableOutput("cleaned_table"))  # Ensures table scrolls
        ),
        tabPanel("📈 Top Tech Tools", plotlyOutput("tech_chart")),
        tabPanel("🏢 Industry Analysis", plotlyOutput("industry_chart")),
        tabPanel("💼 Employment Rate", plotlyOutput("employment_chart"))
      )
    )
  )
)


# Server Logic
server <- function(input, output) {
  # Data Cleaning Output
  output$cleaned_table <- renderDataTable({
    datatable(
      get_cleaned_data(df),
      options = list(
        pageLength = 10,  # Show 10 rows per page
        autoWidth = TRUE,  # Adjust column width dynamically
        scrollX = TRUE,  # Enable horizontal scrolling
        dom = 'tip',  # Enables pagination but removes search/filter
        class = "nowrap display",  # Prevents text wrapping
        escape = FALSE  # Allow proper text rendering
      ),
      rownames = FALSE  # Hide row numbers
    )
  })
  
  # Tech Tools Visualization
  output$tech_chart <- renderPlotly({
    visualize_top_tech_tools(df, input$study_field, input$tech_category)
  })
  
  # Industry Distribution
  output$industry_chart <- renderPlotly({
    visualize_industry_distribution(df, input$study_field)
  })
  
  # Employment Rate Visualization
  output$employment_chart <- renderPlotly({
    plot <- visualize_employment_rate(df)
    if (is.null(plot)) {
      return(plotly_empty())  # Return empty plot if NULL
    } else {
      return(plot)
    }
  })
}

# Run the Shiny App
shinyApp(ui = ui, server = server)
