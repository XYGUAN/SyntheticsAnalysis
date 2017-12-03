library(shinydashboard)
library(dplyr)


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  # patients_data_clean_10000 <- reactive({
  #   unique_patients_ID <- unique(patients_data_clean_10000$patients_ID)
  #   unique_patients_ID_selected <- sample(unique_patients_ID, input$total_patients_number)
  #   patients_data_clean_10000 <- 
  #     patients_data_clean_10000 %>%
  #     filter(patients_ID %in% unique_patients_ID_selected)   
  # })
    
  # Value box
  output$Total_Patient_Box <- renderValueBox({
    number_patients <- max(patients_data_clean_10000$patients_ID)
    valueBox(
      number_patients, "Total patients", 
      color = "blue"
    )
  })
  
  output$Target_Patient_Box <- renderValueBox({
    number_patients_targeted <- 
      patients_data_clean_10000 %>% 
        filter(prevalances == input$prevalance) %>%
        nrow()
    valueBox(
      number_patients_targeted, "Targeted patients", 
      color = "red"
    )
  })
  
  output$Average_weight <- renderValueBox({
    analysis <- personality_prevalances(input$prevalance, patients_data_clean_10000, input$top_n_relevant_prevalance)
    description <- analysis$descrition
    
    valueBox(
      round(description$weight[9]), "Average weigths",
      color = "orange"
    )
  })
  
  output$Average_age <- renderValueBox({
    analysis <- personality_prevalances(input$prevalance, patients_data_clean_10000, input$top_n_relevant_prevalance)
    description <- analysis$descrition
    
    valueBox(
      round(description$age[9]), "Average age",
      color = "yellow"
    )
  })
  
  
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
      paste("<b>", round(description$age[9]), "years old", "</b><br/>"),
      "The average weight is", 
      paste("<b>", round(description$weight[9]), "pounds", "</b>"))
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
