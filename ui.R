library(shinydashboard)

dashboardPage(
  
  dashboardHeader(title = "Synthea Project"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Introduction", tabName = "introduction", icon = icon("dashboard")),
      menuItem("Personality Reasons", tabName = "PersonalityReasons", icon = icon("cog")), 
      menuItem("Prevalances Reasons", tabName = "PrevalancesReasons", icon = icon("th"))
      
    ),
    selectInput("prevalance", "Please choose the prevalance:", prevalances_names, 
                selectize = FALSE, selected = "drug_overdose"), 
    sliderInput("top_n_relevant_prevalance", "top_n relevant prevalance", 1,20,5) 
    # div("Author: Xiuyang Guan"), 
    # div("Reference: https://www.shinyapps.io/admin/#/dashboard; 
    #                 https://synthetichealth.github.io/synthea/
    #                 https://factfinder.census.gov/
    #                 https://www.vecteezy.com/free-vector/people")
    # sliderInput("total_patients_number", "total patients number", 1,56686,56686, step = 100), 
    # 
    # selectInput("prevalance_association", "Please choose the prevalance for association rules:", 
    #             prevalances_names, selectize = FALSE, selected = "drug_overdose")
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "introduction",
              
              fluidRow(
                box(htmlOutput("introduction"), width = 12)
              ), 
              
              fluidRow(
                valueBoxOutput("Total_Patient_Box", width = 6), 
                valueBoxOutput("Target_Patient_Box", width = 6)
                # valueBoxOutput("Average_weight", width = 3), 
                # valueBoxOutput("Average_age", width = 3)
              ), 
              
              fluidRow(
                box(htmlOutput("description"), width = 12), 
                box(htmlOutput("following"), width = 12)
              )
              
      ), 
      
      
      
      tabItem(tabName = "PersonalityReasons",
              
              fluidRow(
                box(htmlOutput("personality_introduction"), width = 12)
              ), 
              
              fluidRow(
                box(plotOutput("single_gender_plot", height = "250px"), width = 4), 
                box(plotOutput("single_race_plot", height = "250px"), width = 8), 
                box(d3tree3Output("treemap_personality", width = "100%", height = "400px"), width = 12)
              ), 
              
              fluidRow(
                
                box(plotOutput("age_density_plot", height = "150px"), width = 6), 
                box(plotOutput("weight_density_plot", height = "150px"), width = 6)
                
              )
              
              
      ), 
      
      tabItem(tabName = "PrevalancesReasons",
              
              fluidRow(
                box(htmlOutput("prevalance_introduction"), width = 12)
              ), 
              
              fluidRow(
                box(plotOutput("relevant_prevalance_plot", height = "250px"), width = 12)
              ), 
              
              fluidRow(
                box(htmlOutput("chord_diagram_title"),
                    chorddiagOutput("chord_diagram"), 
                    width = 6), 
                box(plotOutput("association_rules_net_plot_to_target"), width = 6)
                
              )
              
      )
      
      
      

    )
    
  )
)

