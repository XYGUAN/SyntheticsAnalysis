# The author is Xiuyang Guan

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
      paste(round(description$age[1]/max(patients_data_clean_10000$patients_ID), 3) * 100, "%", sep = ""), 
      "weigths",
      color = "orange"
    )
  })
  
  # output$Average_age <- renderValueBox({
  #   analysis <- personality_prevalances(input$prevalance, patients_data_clean_10000, input$top_n_relevant_prevalance)
  #   description <- analysis$descrition
  #   
  #   valueBox(
  #     round(description$age[9]), "Average age",
  #     color = "yellow"
  #   )
  # })
  
  
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
  
  output$association_rules_net_plot_to_target <- renderPlot({
    selected_prevalance_association <- input$prevalance_association
    rules <- apriori(data = prevalances_items, parameter=list(support=0.001, confidence=0.001), 
                     appearance = list(default="lhs", rhs = selected_prevalance_association), 
                     control = list(verbose = F))
    subrules2 <- head(sort(rules, by="lift"), 10)
    plot(subrules2, method="graph", control=list(type="items") )

  })
  
  output$association_rules_net_plot_from_target <- renderPlot({
    selected_prevalance_association <- input$prevalance_association
    rules <- apriori(data = prevalances_items, parameter=list(support=0.001, confidence=0.001), 
                     appearance = list(default="rhs", lhs = selected_prevalance_association), 
                     control = list(verbose = F))
    subrules2 <- head(sort(rules, by="lift"), 10)
    plot(subrules2, method="graph", control=list(type="items") )
    
  })
  
})
