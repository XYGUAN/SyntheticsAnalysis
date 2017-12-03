library(shinydashboard)

dashboardPage(
  
  dashboardHeader(title = "Synthetics Analysis"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Analysis", tabName = "analysis", icon = icon("th")),
      menuItem("Exploration", tabName = "explore", icon = icon("cog"))
    ),
    selectInput("prevalance", "Please choose the prevalance:", prevalances_names, 
                selectize = TRUE, multiple = TRUE), 
    sliderInput("top_n_relevant_prevalance", "top_n relevant prevalance", 1,20,5)
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "dashboard",
              
              fluidRow(
                box(htmlOutput("description"), width = 12)
              ), 
              
              fluidRow(
                box(plotOutput("relevant_prevalance_plot", height = "250px"), width = 12)
              ), 
              
              fluidRow(
                box(plotOutput("single_gender_plot", height = "250px"), width = 4), 
                box(plotOutput("single_race_plot", height = "250px"), width = 8)
              ), 
              
              fluidRow(
                
                box(plotOutput("age_density_plot", height = "150px"), width = 6), 
                box(plotOutput("weight_density_plot", height = "150px"), width = 6)
              )
              
              
            
              
      ),
      
      
      tabItem(tabName = "analysis",
              fluidRow(
                box(plotOutput("Analysis"),width = 12)
              )
              
      )
      

    )
    
  )
)