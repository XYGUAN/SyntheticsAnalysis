library(dplyr)

patients_data_10000 <- read.table("resources/patients_data_10000.txt", sep = "\n")

transform_data <- function(data_input){
  data_input <- as.character(data_input)
  personality <- strsplit(strsplit(data_input, split = "-- ")[[1]][1], split = "[.]")
  name <- strsplit(personality[[1]][1], split = ": ")
  race <- trimws(personality[[1]][2], "l")
  age <- as.numeric(strsplit(personality[[1]][3], split = " ")[[1]][2])
  gender <- strsplit(personality[[1]][3], split = " ")[[1]][4]
  weight <- as.numeric(strsplit(personality[[1]][3], split = " ")[[1]][5])
  prevalances <- strsplit(strsplit(a, split = "-- ")[[1]][2], split = ", ")[[1]]
  
  result <- data.frame(name = name, race = race, age = age, gender = gender, 
             weight = weight, prevalances = prevalances)
  return(result)
}






