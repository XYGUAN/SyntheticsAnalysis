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
                selectize = FALSE, selected = "drug_overdose"), 
    sliderInput("top_n_relevant_prevalance", "top_n relevant prevalance", 1,20,5), 
    sliderInput("total_patients_number", "total patients number", 1,56686,56686, step = 100)
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "dashboard",
              
              fluidRow(
                valueBoxOutput("Total_Patient_Box", width = 3), 
                valueBoxOutput("Target_Patient_Box", width = 3), 
                valueBoxOutput("Average_weight", width = 3), 
                valueBoxOutput("Average_age", width = 3)
              ), 
              
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