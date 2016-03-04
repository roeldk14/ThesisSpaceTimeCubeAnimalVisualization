### STC_Reproject_Lat/Long_Dataframe_to_UTM_Functions_Script  Space_Time_Cube_Animal_Visualization
### 03\03\16


##: Thanks and rights for the original script go to Josh O'Brein from Stackoverflow

STC_UTM_Calculator <- function(dataframe) {
  
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
  
  dataframe <- STC_UTM_Zone_Calculator(dataframe)
  
  dataframe$UTM.East <- NA
  dataframe$UTM.North <- NA
  len <- length(dataframe$lat)
  
  for (i in 1:len) {
    work.df <- data.frame("X" = dataframe$long[i], "Y" = dataframe$lat[i])
    attr(work.df,"zone") <- dataframe$utmzone[i]
    attr(work.df,"projection") <- "LL"
    work.utm <- convUL(work.df,km = FALSE)
    dataframe$UTM.East[i] <- work.utm[1]
    dataframe$UTM.North[i] <- work.utm[2]
  }
  
  return(dataframe)
  
}