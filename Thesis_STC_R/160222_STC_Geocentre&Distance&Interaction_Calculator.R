### STC_Geocentre_ and Distance_Calculator_Script Space_Time_Cube_Animal_Visualization
### 22\02\16

### Calculates the geo central or mid point for a given dataset of coordinates
### (written to be set within the functions : STC_Population_Averaged_Track_Calculator
### and STC_Individual_Averaged_Track_Calculator)

## calculating a central geo point part 1

geocentrecalcPt1 <- function(long,lat) {
  ## convert to cartesian coordinates
  
  long1 <- long * pi / 180
  lat1 <- lat * pi / 180
  
  ## calculate curvature x,y,z values
  
  x1 <- cos(lat1) * cos(long1)
  y1 <- cos(lat1) * sin(long1)
  z1 <- sin(lat1)
  
  return(c(x1,y1,z1))
}

## calculating a central geo point part 2

geocentrecalcPt2 <- function(xlist,ylist,zlist) {
  ## calculate average of x, y and z values
  
  x <- mean(x.list)
  y <- mean(y.list)
  z <- mean(z.list)
  
  ## transform back to cartesian coordinates
  
  long <- atan2(y,x)
  hyp <- sqrt(x * x + y * y)
  lat <- atan2(z,hyp)
  
  ## calculate average long and lat
  
  long <- long * 180 / pi
  lat <- lat * 180 / pi
  
  return(c(long,lat))
  
}

########################################################################################
########################################################################################

##Retrieve outliers from the dataset based on the geo distance between points with the same time stamp

Distance_Outlier_Calculator <-
  function(total_dataframe,pop_dataframe,t1,t2, outlier_buffer_in_km = 100) {
    ## test for correctly inputted date format
    
    testt1 <- grep("[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]", t1)
    testt2 <- grep("[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]", t2)
    
    if (any(isTRUE(all.equal(testt1,integer(0))) == TRUE |
            isTRUE(all.equal(testt2,integer(0))) == TRUE))
      stop("t1 and t2 dates must be in format Year-Month-Date (1999-12-31)")
    
    ##construct Identification list and datum
    
    start_date <- as.Date.character(t1)
    end_date <- as.Date.character(t2)
    
    ## create list containing calendar dates of interest
    
    Movement_Calendar <-
      seq.Date(from = start_date,to = end_date,by = 1)
    
    Numeric_Movement_Calendar <- as.numeric(Movement_Calendar)
    
    print(paste("Number of days being analysed =", length(Movement_Calendar)))
    
    ## construct neccscary list objects
    
    long.list <- c()
    lat.list <-  c()
    Identifier.names <- c()
    TimeDate <- c()
    TimeDateNumeric <- c()
    Distance_list <- c()
    UTM.East.list <- c()
    UTM.North.list <- c()
    utmzone <- c()
    
    ## loop calculating the distance between points recorded on the same day, identifying outliers
    
    for (i in 1:length(Movement_Calendar)) {
      ## check for movement dates matching dates in the movement calendar
      
      Truecheck <-
        pop_dataframe$TimeDate == Movement_Calendar[i]
      
      if (length(Truecheck[Truecheck == "TRUE"]) > 0) {
        ## select rows matching the movement calendar date of interest if present
        
        pop_dataframe_time_selection_single <-
          pop_dataframe[pop_dataframe$TimeDate == Movement_Calendar[i],]
        
        Truecheck2 <-
          total_dataframe$TimeDate == Movement_Calendar[i]
        
        if (length(Truecheck2[Truecheck2 == "TRUE"]) > 0) {
          ## select rows matching the movement calendar date of interest if present
          
          total_dataframe_time_selection <-
            total_dataframe[total_dataframe$TimeDate == Movement_Calendar[i],]
          
          
          for (j in 1:length(total_dataframe_time_selection)) {
            total_dataframe_time_selection_single <-
              total_dataframe_time_selection[j,]
            
            long1 = pop_dataframe_time_selection_single$long
            lat1 = pop_dataframe_time_selection_single$lat
            long2 = total_dataframe_time_selection_single$long
            lat2 = total_dataframe_time_selection_single$lat
            
            distance <-
              rdist.earth(matrix(c(long1,lat1), ncol = 2),matrix(c(long2,lat2), ncol =
                                                                   2),miles = FALSE, R = 6371)
            
            long.list <- append(long.list,long2)
            lat.list <-  append(lat.list,lat2)
            Distance_list <- append(Distance_list,distance)
            Identifier.names <-
              append(Identifier.names,total_dataframe_time_selection_single$Identifier)
            TimeDate <-
              append(TimeDate,total_dataframe_time_selection_single$TimeDate)
            TimeDateNumeric <-
              append(
                TimeDateNumeric,total_dataframe_time_selection_single$TimeDateNumeric
              )
            UTM.East.list <-
              append(UTM.East.list,total_dataframe_time_selection_single$UTM.East[[1]])
            UTM.North.list <-
              append(UTM.North.list,total_dataframe_time_selection_single$UTM.North[[1]])
            utmzone <-
              append(utmzone,total_dataframe_time_selection_single$utmzone)
            
          }
        }
      }
    }
    long.list <- na.omit(long.list)
    lat.list <- na.omit(lat.list)
    Distance_list <- na.omit(Distance_list)
    Identifier.names <- na.omit(Identifier.names)
    TimeDate <- na.omit(TimeDate)
    TimeDateNumeric <- na.omit(TimeDateNumeric)
    utmzone <- na.omit(utmzone)
    
    output.df <-
      data.frame(
        "long" = long.list,"lat" = lat.list, "Identifier" = Identifier.names,
        TimeDate,TimeDateNumeric, "UTM.East" = UTM.East.list, "UTM.North" = UTM.North.list,
        utmzone, "Distance" = Distance_list, check.names = T,check.rows = T,
        stringsAsFactors = F
      )
    
    output.df <- output.df[output.df$Distance > outlier_buffer_in_km,]
    
    return(output.df)
  }

########################################################################################
########################################################################################

Distance_Interaction_Calculator <-
  function(total_dataframe,t1,t2, interaction_radius_in_km = 10) {
    ## test for correctly inputted date format
    
    testt1 <- grep("[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]", t1)
    testt2 <- grep("[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]", t2)
    
    if (any(isTRUE(all.equal(testt1,integer(0))) == TRUE |
            isTRUE(all.equal(testt2,integer(0))) == TRUE))
      stop("t1 and t2 dates must be in format Year-Month-Date (1999-12-31)")
    
    ##construct Identification list and datum
    
    start_date <- as.Date.character(t1)
    end_date <- as.Date.character(t2)
    
    ## create list containing calendar dates of interest
    
    Movement_Calendar <-
      seq.Date(from = start_date,to = end_date,by = 1)
    
    Numeric_Movement_Calendar <- as.numeric(Movement_Calendar)
    
    print(paste("Number of days being analysed =", length(Movement_Calendar)))
    
    ## construct neccscary list objects
    
    long.list <- c()
    lat.list <-  c()
    Identifier.names <- c()
    TimeDate <- c()
    TimeDateNumeric <- c()
    Distance_list <- c()
    UTM.East.list <- c()
    UTM.North.list <- c()
    utmzone <- c()
    
    total_dataframe_alpha <- total_dataframe
    total_dataframe_beta <- total_dataframe
    
    ## loop calculating the distance between points recorded on the same day, identifying outliers
    
    for (i in 1:length(Movement_Calendar)) {
      ## check for movement dates matching dates in the movement calendar
      
      ## select rows matching the movement calendar date of interest if present
      
      Truecheck <-
        total_dataframe_alpha$TimeDate == Movement_Calendar[i]
      
      if (length(Truecheck[Truecheck == "TRUE"]) > 0) {
        ## select rows matching the movement calendar date of interest if present
        
        total_dataframe_alpha_time_selection <-
          total_dataframe_alpha[total_dataframe_alpha$TimeDate == Movement_Calendar[i],]
        
        total_dataframe_beta_time_selection <-
          total_dataframe_beta[total_dataframe_beta$TimeDate == Movement_Calendar[i],]
        
        
        for (j in 1:length(total_dataframe_alpha_time_selection)) {
          total_dataframe_alpha_time_selection_single <-
            total_dataframe_alpha_time_selection[j,]
          
          for (k in 1:length(total_dataframe_beta_time_selection)) {
            
            long1 = total_dataframe_alpha_time_selection$long
            lat1 = total_dataframe_alpha_time_selection$lat
            long2 = total_dataframe_beta_time_selection$long
            lat2 = total_dataframe_beta_time_selection$lat
            
            distance <-
              rdist.earth(matrix(c(long1,lat1), ncol = 2),matrix(c(long2,lat2), ncol =
                                                                   2),miles = FALSE, R = 6371)
            
            long.list <- append(long.list,long2)
            lat.list <-  append(lat.list,lat2)
            Distance_list <- append(Distance_list,distance)
            Identifier.names <-
              append(Identifier.names,total_dataframe_beta_time_selection$Identifier)
            TimeDate <-
              append(TimeDate,total_dataframe_beta_time_selection$TimeDate)
            TimeDateNumeric <-
              append(TimeDateNumeric,total_dataframe_beta_time_selection$TimeDateNumeric)
            UTM.East.list <-
              append(UTM.East.list,total_dataframe_beta_time_selection$UTM.East[[1]])
            UTM.North.list <-
              append(UTM.North.list,total_dataframe_beta_time_selection$UTM.North[[1]])
            utmzone <-
              append(utmzone,total_dataframe_beta_time_selection$utmzone)
            
          }
        }
      }
    }
    long.list <- na.omit(long.list)
    lat.list <- na.omit(lat.list)
    Distance_list <- na.omit(Distance_list)
    Identifier.names <- na.omit(Identifier.names)
    TimeDate <- na.omit(TimeDate)
    TimeDateNumeric <- na.omit(TimeDateNumeric)
    utmzone <- na.omit(utmzone)
    
    output.df <-
      data.frame(
        "long" = long.list,"lat" = lat.list, "Identifier" = Identifier.names,
        TimeDate,TimeDateNumeric, "UTM.East" = UTM.East.list, "UTM.North" = UTM.North.list,
        utmzone, "Distance" = Distance_list, check.names = T,check.rows = T,
        stringsAsFactors = F
      )
    
    output.df <- output.df[output.df$Distance < interaction_radius_in_km & output.df$Distance > 0,]
    
    return(output.df)
  }
