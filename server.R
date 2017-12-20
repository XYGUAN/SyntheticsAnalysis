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
      number_patients_targeted, "Selected patients", 
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
  
  output$introduction <- renderUI({
    
    HTML("<h2><center> The Drug Overdose Patients in PA</center></h2>
         <p> This project aims to analyze the regional healthcare situation, based on the patient’s data in Philadelphia City. Using this project, the users can detect the following fields: </p>
         <ul>
            <li>The characteristics of the people who has the drug prevalance</li>
            <li>The relationship between the drug overdose and other prevalance.</li>
            <li>The overall situation of the Philadelphia City.</li>
         </ul>
         <p> The overall situation for the people and patients in Philadelphia City is: </p>")

  })
  
  output$following <- renderUI({
    
    HTML("In the following part, there are two sections to analyze the reasons why the patients will have the drug overdose: 
         <ul>
            <li><b>The presonality reasons. </b>In this part, the weights, races, gender and different distribution will be explored.</li>
            <li><b>The prevalances reasons. </b>In this part, the connected prevalances and the correlated ones will be detected and explored. </li>
         </ul>
         <p>In addition to the drug overdose, used the left side control and options bar, users can also choose the different focused prevalance and the number of related prevalance want to be focused.</p>")
    
  })
  
  output$personality_introduction <- renderUI({
    
    HTML("<h2><center>The Presonality Analysis</center></h2>
          <p> In this section, the analysis of the influence of the gender, age and race will be shown. We found that: 
          <ul>
            <li><b>There are more male patients than female ones </b></li>
            <li><b>The black Americans, black Dominican and White Irish tend to be more drug overdosed</b></li>
            <li><b>The Hispanic Central American has a severe sex inbalance, which means the female Hispanic Central American tends to have more drug overdoses</b></li>
         </ul>")
    
  })
  
  output$prevalance_introduction <- renderUI({
    
    HTML("<h2><center>The Prevalance Analysis</center></h2>
         <p> In this section, the analysis of the influence of the other prevalances will be shown. We found that: 
         <ul>
         <li><b>People who have prediabetes have the most possibility to have the drug overdose.</b></li>
         <li><b>People who have hypertension are also very possible to have the drug overdose.</b></li>
         <li><b>Applied association rules algorithm in the data, we can find that the ted molars can also be directed to the drug overdose. </b></li>
         </ul>")
    
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
    selected_prevalance_association <- input$prevalance
    rules <- apriori(data = prevalances_items, parameter=list(support=0.001, confidence=0.001), 
                     appearance = list(default="lhs", rhs = selected_prevalance_association), 
                     control = list(verbose = F))
    subrules2 <- head(sort(rules, by="lift"), 10)
    plot(subrules2, method="graph", control=list(type="items") )

  })
  
  output$association_rules_net_plot_from_target <- renderPlot({
    selected_prevalance_association <- input$prevalance
    rules <- apriori(data = prevalances_items, parameter=list(support=0.001, confidence=0.001), 
                     appearance = list(default="rhs", lhs = selected_prevalance_association), 
                     control = list(verbose = F))
    subrules2 <- head(sort(rules, by="lift"), 10)
    plot(subrules2, method="graph", control=list(type="items") )
    
  })
  
  output$chord_diagram <- renderChorddiag({
    
    selected_prevalance_association <- input$prevalance
    data_targeted_ID <- 
      patients_data_clean_10000 %>%
      filter(prevalances == selected_prevalance_association) %>%
      select(patients_ID) %>%
      unlist() %>%
      as.numeric()
    
    data_targeted <- 
      patients_data_clean_10000 %>%
      filter(patients_ID %in% data_targeted_ID) %>%
      group_by(prevalances) %>%
      summarise(n = n()) %>%
      filter(prevalances != selected_prevalance_association)
    
    names(data_targeted)[2] <- "drug_overdose" 
    data_targeted_mat <- t(as.matrix(data_targeted[2]))
    colnames(data_targeted_mat) <- as.character(data_targeted$prevalances)
    
    chorddiag(data_targeted_mat, type = "bipartite", showTicks = F, showGroupnames = F, 
              groupnameFontsize = 14, groupnamePadding = 10, margin = 10)
    
  })
  
  output$treemap_personality <- renderD3tree3({
    
    selected_prevalance_association <- input$prevalance
    
    data_targeted <- 
      patients_data_clean_10000 %>%
      filter(prevalances == selected_prevalance_association) %>%
      group_by(race) %>%
      mutate(n_Male = ifelse(gender == "M", 1, 0), 
             n_Female = ifelse(gender == "F", 1, 0)) %>%
      summarise(race_sum = n(), sum_Male = sum(n_Male), sum_Female = sum(n_Female)) %>%
      mutate(sum_Female/sum_Male)
    
    names(data_targeted)[5] <- "sex_ratio_Female_devide_Male"
    
    d3tree3(
      treemap(data_targeted,
            index=c("race"),
            vSize="race_sum",
            vColor="sex_ratio_Female_devide_Male",
            type="value"), 
      rootname = "Treemap for different race"
    )
    
  })
  
  output$chord_diagram_title <- renderUI({
    HTML("<h4><center><b> Chord Diagram for prevalances </b></center></h4>
          <p><center><l> Please slip over the diagram to see that correlation </l></center></p>")
    
  })

  
})
