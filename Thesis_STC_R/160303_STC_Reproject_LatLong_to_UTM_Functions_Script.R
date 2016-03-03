### STC_Reproject_Lat/Long_Dataframe_to_UTM_Functions_Script  Space_Time_Cube_Animal_Visualization
### 03\03\16


##: Thanks and rights for the original script go to Josh O'Brein from Stackoverflow

STC_UTM_Zone_Calculator <- function(dataframe) {
  
  utmzones <- c() 
  
  long2UTM <- function(long) {
    (floor((long + 180)/6) %% 60) + 1
  }
  
  for (i in 1:length(dataframe$long)) {
    utmvalue <- long2UTM(dataframe$long[i])
    utmzones <- append(utmzones,utmvalue)
  }
  dataframe$utmzone <- utmzones 
  return(dataframe)
}

STC_UTM_Calculator <- function(dataframe.long,dataframe.lat,dataframe.utmzone) {
  work.df <- data.frame("X" = dataframe.long, "Y" = dataframe.lat, "utmzone" = dataframe.utmzone)
  
  
}

dataframe2 <- convUL(work.df)



dataframe.long <- dataframe$long
dataframe.lat <- dataframe$lat
dataframe.utmzone <- dataframe$utmzone
