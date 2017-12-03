library(dplyr)
library(ggplot2)
library(pastecs)

patients_data_clean_10000 <- read.csv("data/patients_data_clean_10000.csv")
patients_data_clean_10000 <- tbl_df(patients_data_clean_10000)
prevalances_names <- names(table(patients_data_clean_10000$prevalances))

personality_prevalances <- function(input_prevalance, data_reference, top_n_relevant_prevalance){
  top_n_relevant_prevalance <- top_n_relevant_prevalance + 1
  
  targeted_data <- 
    data_reference %>%
    filter(prevalances == input_prevalance)
  
  targeted_data_description <- stat.desc(targeted_data)
  
  gender_ggplot <- 
    ggplot(targeted_data, aes(x = gender, fill = gender)) + 
      geom_bar(aes(y = (..count..)/sum(..count..) * 100)) + 
      ylab("Percent (%)") + 
      ggtitle("The distribution of gender") +
      theme(plot.title = element_text(hjust = 0.5))
  
  race_ggplot <- 
    ggplot(targeted_data, aes(x = race, fill = race)) + 
    geom_bar(aes(y = (..count..)/sum(..count..) * 100)) + 
    ylab("Percent (%)") + 
    ggtitle("The distribution of race") + 
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    theme(plot.title = element_text(hjust = 0.5))
  
  age_density_gender_ggplot <- 
    ggplot(targeted_data, aes(age, fill = gender)) +
      geom_density(alpha = 0.5) + 
      xlab("Age") + 
      ylab("Density") + 
      ggtitle("Distribution of Age") +
      theme(plot.title = element_text(hjust = 0.5))
  
  weight_density_gender_ggplot <- 
    ggplot(targeted_data, aes(weight, fill = gender)) +
      geom_density(alpha = 0.5) + 
      xlab("Weight") + 
      ylab("Density") + 
      ggtitle("Distribution of Weight") + 
      theme(plot.title = element_text(hjust = 0.5))
  
  relevant_prevalance_data <- 
    data_reference %>%
    filter(patients_ID %in% targeted_data$patients_ID)
  
  relevant_prevalance_data_vector <- table(relevant_prevalance_data$prevalances)
  relevant_prevalance_data_vector <- relevant_prevalance_data_vector[relevant_prevalance_data_vector != 0]
  relevant_prevalance_data_vector_top_n <- sort(relevant_prevalance_data_vector, decreasing = TRUE)[1:top_n_relevant_prevalance]
  relevant_prevalance_to_df <- function(Name, total_n, N){
    return(data.frame(prevalance = Name, relevant = c(rep(TRUE, N), rep(FALSE, (total_n-N)))))
  }
  
  total_n <- nrow(targeted_data)
  relevant_prevalance_plot_data <- 
    relevant_prevalance_to_df(names(relevant_prevalance_data_vector_top_n[1]), total_n = total_n, relevant_prevalance_data_vector_top_n[1])
  for(i in 2:top_n_relevant_prevalance){
    relevant_prevalance_plot_data <- rbind(relevant_prevalance_plot_data, 
                                           relevant_prevalance_to_df(names(relevant_prevalance_data_vector_top_n[i]), 
                                                                     total_n = total_n, relevant_prevalance_data_vector_top_n[i]))
  }
  relevant_prevalance_plot_data <- tbl_df(relevant_prevalance_plot_data)
  relevant_prevalance_plot_data <- 
    relevant_prevalance_plot_data %>%
    filter(prevalance != input_prevalance)
  
  relevant_prevalance_plot_data$relevant <- factor(relevant_prevalance_plot_data$relevant, levels=c("FALSE", "TRUE"))
  
  relevant_prevalance_plot <- 
    ggplot(data=relevant_prevalance_plot_data, aes(x=reorder(prevalance, relevant_prevalance_plot_data$relevant=="TRUE", sum), fill=relevant)) +
      geom_bar(position='fill') +
      scale_fill_brewer(palette="Set2") +
      xlab("prevalance") + 
      ylab("percentage") + 
      coord_flip() + 
      theme(axis.text.y = element_text(angle = 45, hjust = 1)) + 
      ggtitle("Relevant prevalances") + 
      theme(plot.title = element_text(hjust = 0.5))
  
  # Combine to the results
  result_list <- list(targeted_data_description, gender_ggplot, race_ggplot,
                      age_density_gender_ggplot, weight_density_gender_ggplot, 
                      relevant_prevalance_plot)
  
  names(result_list) <- c("descrition", "gender_plot", "race_plot", 
                          "age_density_gender_plot", "weight_density_gender_plot", "relevant_prevalance_plot")
  
  return(result_list)
}


