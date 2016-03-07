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

Distance_Outlier_Calculator <- function(total.dataframe,pop.dataframe,t1,t2, outlier_radius = 1000) {
  
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
  Distance.list <- c()
  UTM.East.list <- c()
  UTM.North.list <- c()
  utmzone <- c()
  
  ## loop calculating the distance between points recorded on the same day, identifying outliers
  
  for (i in 1:length(Movement_Calendar)) {
    ## check for movement dates matching dates in the movement calendar
    
    Truecheck <-
      pop.dataframe$TimeDate == Movement_Calendar[i]
    
    if (length(Truecheck[Truecheck == "TRUE"]) > 0) {
      ## select rows matching the movement calendar date of interest if present
      
      pop.dataframe.time.selection.single <-
        pop.dataframe[pop.dataframe$TimeDate == Movement_Calendar[i],]
      
      Truecheck <-
        total.dataframe.time.selection$TimeDate == Movement_Calendar[i]
      
      if (length(Truecheck[Truecheck == "TRUE"]) > 0) {
        ## select rows matching the movement calendar date of interest if present
        
        total.dataframe.time.selection <-
          total.dataframe.time.selection[total.dataframe.time.selection$TimeDate == Movement_Calendar[i],]
        
        
        for (j in 1:length(total.dataframe.time.selection)) {
          
          total.dataframe.time.selection.single <-
            total.dataframe.time.selection[total.dataframe.time.selection[j],]
          
          long1 = pop.dataframe.time.selection.single$long
          lat1 = pop.dataframe.time.selection.single$lat
          long2 = total.dataframe.time.selection.single$long
          lat2 = total.dataframe.time.selection.single$lat
          
          distance <- rdist.earth(matrix(c(long1,lat1), ncol=2),matrix(c(long2,lat2), ncol=2),miles=FALSE, R=6371)
          
          
          
          
          
          
          long.list <- append(long.list,long2)
          lat.list <-  append(lat.list,lat2)
          distance.list <- append(distance.list,distance)
          Identifier.names <- append(Identifier.names,total.dataframe.time.selection.single$Identifier[i])
          TimeDate <- append(TimeDate,total.dataframe.time.selection.single$TimeDate[i])
          TimeDateNumeric <- append(TimeDateNumeric,total.dataframe.time.selection.single$TimeDateNumeric[i])
          UTM.East.list <- append(UTM.East.list,total.dataframe.time.selection.single$UTM.East)
          UTM.North.list <- append(UTM.North.list,total.dataframe.time.selection.single$UTM.North)
          utmzone <- append(utmzone,total.dataframe.time.selection.single$utmzone)
          
          
          
          
        }
      }
    }
  }
  
}

