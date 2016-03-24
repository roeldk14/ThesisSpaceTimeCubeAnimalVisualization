### STC_Population_Averaged_Track_Calculator_Script Space_Time_Cube_Animal_Visualization
### 22\02\16

### Calculates the population average track from multiple individuals for a given dataset

STC_Population_Averaged_Track_Calculator <-
  function(dataframe,t1,t2,identifier.name) {
    
    #dataframe <- Individual_Averaged_Animal_Movement_Tracks.df # for testing if needed
    
    ###############################################################################
    ##  neccescary geocentre calculator script
    
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
    
    ###############################################################################
    
    ## test for correctly inputted date format
    
    testt1 <- grep("[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]", t1)
    testt2 <- grep("[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]", t2)
    
    if (any(isTRUE(all.equal(testt1,integer(0))) == TRUE |
            isTRUE(all.equal(testt2,integer(0))) == TRUE))
      stop("t1 and t2 dates must be in format Year-Month-Date (1999-12-31)")
    
    ##construct Identification list and datum
    
    start_date <- as.Date.character(t1)
    end_date <- as.Date.character(t2)
    
    ## Create unique identifier
    
    Identifier <- identifier.name
    
    print(paste("unique identifer =",(Identifier)))
    
    ## create list containing calendar dates of interest
    
    Movement_Calendar <-
      seq.Date(from = start_date,to = end_date,by = 1)
    
    Numeric_Movement_Calendar <- as.numeric(Movement_Calendar)
    
    print(paste("Number of days being analysed =", length(Movement_Calendar)))
    
    ## construct neccescary list objects
    
    pop.long.list <- c()
    pop.lat.list <- c()
    pop.Identifier <- c()
    pop.TimeDate <- c()
    pop.TimeDateNumeric <- c()
    pop.Days_Count <- c()
    
    ## loop calculating the average lat/long for the population per unique date
    
    ## loop through movement calendar
    
    for (j in 1:length(Movement_Calendar)) {
      ## check for movement dates matching dates in the movement calendar
      
      Truecheck <-
        dataframe$TimeDate == Movement_Calendar[j]
      
      if (length(Truecheck[Truecheck == "TRUE"]) > 1) {
        ## select rows matching the movement calendar date of interest if present and
        ## if there is more then one record
        
        dataframe.selection <-
          dataframe[dataframe$TimeDate == Movement_Calendar[j],]
        
        
        ## construct neccescary list objects and empty when looped
        
        x.list <- c()
        y.list <- c()
        z.list <- c()
        
        ## for each specific record (row) run it through the geocentre calc pt 1
        
        for (k in 1:nrow(dataframe.selection)) {
          CurrentRecord <- dataframe.selection[k,]
          
          long00 <- CurrentRecord$long
          lat00 <- CurrentRecord$lat
          
          xyzvalues <- geocentrecalcPt1(long = long00,lat = lat00)
          
          x.list <- append(x.list,xyzvalues[1])
          y.list <- append(y.list,xyzvalues[2])
          z.list <- append(z.list,xyzvalues[3])
          
        }
        
        ## run collected points through the geocentre calc pt 2
        
        latlongvalues <- geocentrecalcPt2(x.list,y.list,z.list)
        
        ## append outputted long,lat as well as identifier and date to relevant lists
        
        pop.long.list <- append(pop.long.list,latlongvalues[1])
        pop.lat.list <- append(pop.lat.list,latlongvalues[2])
        pop.Identifier <- append(pop.Identifier,Identifier)
        pop.TimeDate <- append(pop.TimeDate,Movement_Calendar[j])
        pop.TimeDateNumeric <- append(pop.TimeDateNumeric,Numeric_Movement_Calendar[j])
        pop.Days_Count <- append(pop.Days_Count,dataframe.selection$Days_Count[1])
      }
    }
    
    ##construct a dataframe from the completed lists
    
    Population_mean_track.df <-
      data.frame(
        "long" = pop.long.list, "lat" = pop.lat.list,"Identifier" = pop.Identifier,
        "TimeDate" = pop.TimeDate,"TimeDateNumeric" = pop.TimeDateNumeric,"Days_Count" = pop.Days_Count, stringsAsFactors = F)
    
    return(Population_mean_track.df)
  }

## check dataframe output as neccescary

#head(Population_mean_track_df)
