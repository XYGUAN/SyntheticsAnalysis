library(shinydashboard)
source("DecisionTree.R")


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # The dashboard tab page
  output$DecitionTree <- renderPlot({
    model.generation(input$state, model = "Tree", output = input$target, min_split = input$min_split, max_depth = input$max_depth)
  })
  
  output$NoCountiesBox <- renderValueBox(
    if(input$state == "tri-state"){
      valueBox(
        length(which(table(tristate.data$County) != 0)), "Number of Counties", icon = icon("list")
      )
    }
    else{
      valueBox(
        length(which(table(original.data[original.data$State == input$state,]$County) != 0)), "Number of Counties", icon = icon("list")
      )
    }
  )
  
  # The analysis tab page
  output$Analysis <- renderPlot({
    model.generation.error(input$state, model = "Tree", output = input$target)
  })
  
  # The condition tab page
  output$Condition <- renderTable({
    condition_temp <- unlist(strsplit(input$condition, " "))
    table.condition(input$state, condition_temp[1], condition_temp[2], condition_temp[3])
  })
  
})
