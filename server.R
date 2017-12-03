library(shinydashboard)
library(dplyr)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # The texts
  output$description <- renderUI({
    analysis <- personality_prevalances(input$prevalance, patients_data_clean_10000, input$top_n_relevant_prevalance)
    description <- analysis$descrition
    

    HTML(paste(
      "There are", 
      paste("<b>", round(description$age[1]), "</b>"), 
      "patients for the prevalance:", 
      paste("<b>", input$prevalance, "</b><br/>"), 
      "The average age is",
      paste("<b>", round(description$age[9]), "</b><br/>"),
      "The average weight is", 
      paste("<b>", round(description$weight[9]), "</b>"))
    )
    

    
  })
  
  
  # The plots
  output$single_gender_plot <- renderPlot({
    analysis <- personality_prevalances(input$prevalance, patients_data_clean_10000, input$top_n_relevant_prevalance)
    analysis$gender_plot
  })
  
  output$single_race_plot <- renderPlot({
    analysis <- personality_prevalances(input$prevalance, patients_data_clean_10000, input$top_n_relevant_prevalance)
    analysis$race_plot
  })
  
  output$age_density_plot <- renderPlot({
    analysis <- personality_prevalances(input$prevalance, patients_data_clean_10000, input$top_n_relevant_prevalance)
    print(analysis$age_density_gender_plot)
  })
  
  output$weight_density_plot <- renderPlot({
    analysis <- personality_prevalances(input$prevalance, patients_data_clean_10000, input$top_n_relevant_prevalance)
    print(analysis$weight_density_gender_plot)
  })
  
  output$relevant_prevalance_plot <- renderPlot({
    analysis <- personality_prevalances(input$prevalance, patients_data_clean_10000, input$top_n_relevant_prevalance)
    print(analysis$relevant_prevalance_plot)
  })
  
  
  
  
  
  
  
})
