library(dplyr)

patients_data_10000 <- read.delim("resources/patients_data_10000.txt", sep = "\n")

transform_data <- function(data_input){
  data_input <- as.character(data_input)
  personality <- strsplit(strsplit(data_input, split = "-- ")[[1]][1], split = "[.]")
  name <- strsplit(personality[[1]][1], split = ": ")[[1]][2]
  race <- trimws(personality[[1]][2], "l")
  age <- as.numeric(strsplit(personality[[1]][3], split = " ")[[1]][2])
  gender <- strsplit(personality[[1]][3], split = " ")[[1]][4]
  weight <- as.numeric(strsplit(personality[[1]][3], split = " ")[[1]][5])
  prevalances <- strsplit(strsplit(data_input, split = "-- ")[[1]][2], split = ", ")[[1]]
  
  result <- data.frame(name = name, race = race, age = age, gender = gender, 
             weight = weight, prevalances = prevalances)
  return(result)
}

transform_data_run <- function(source_data){
  clean_data <- transform_data(source_data[1,])
  clean_data$patients_ID <- 1
  for(i in 2:nrow(source_data)){
    temp_data <- transform_data(source_data[i,])
    temp_data$patients_ID <- i
    clean_data <- rbind(clean_data, temp_data)
    print(i)
  }
  return(clean_data)
}

clean_data_10000 <- transform_data_run(patients_data_10000)
write.csv(clean_data_10000, "data/patients_data_clean_10000.csv")



