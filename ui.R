library(shinydashboard)

dashboardPage(
  dashboardHeader(title = "Synthetics Analysis"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Analysis", tabName = "analysis", icon = icon("th")),
      menuItem("Exploration", tabName = "explore", icon = icon("cog"))
    ),
    selectInput("state", "Please choose the state:", states.names),
    selectInput("target", "Please choose the target variable:", output.variables),
    sliderInput("min_split", "Please choose the min_split parameter", 1,20,5),
    sliderInput("max_depth", "Please choose the max_depth parameter", 1,20,5),
    helpText("asdfasdfsad")
  ),
  
  dashboardBody(
    tabItems(
      tabItem(tabName = "dashboard",
              fluidRow(
                valueBoxOutput("NoCountiesBox")
              ),
              fluidRow(
                box(plotOutput("DecitionTree"),width = 12)
              )
      ),
      
      tabItem(tabName = "analysis",
              fluidRow(
                box(plotOutput("Analysis"),width = 12)
              )
              
      ),
      
      tabItem(tabName = "explore",
              fluidRow(
                box(
                  title = "Controls",
                  selectInput("state.table", "Please choose the state:", states.names),
                  textInput("condition", "Please type the condition, use , to seperate")
                ),
                box(tableOutput("Condition"))
              ))
    )
    
  )
)