### STC_Individual_Averaged_Track_Calculator_Script Space_Time_Cube_Animal_Visualization
### 16\02\16

### Calculates the Individual averaged tracks from multiple dates for multiple individuals for a given dataset

Individual_Averaged_Tracks_Calculator <- function(dataframe,t1,t2) {

  ## source neccescary geocentre calculator script
  
  source("Thesis_STC_R/160222_STC_Geocentre_Midpoint_Calculator.R")
  
  ## test for correctly inputted date format
  
  testt1 <- grep("[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]", t1)
  testt2 <- grep("[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]", t2)
  
  if (any(isTRUE(all.equal(testt1,integer(0))) == TRUE |
          isTRUE(all.equal(testt2,integer(0))) == TRUE))
    stop("t1 and t2 dates must be in format Year-Month-Date (1999-12-31)")
  
  ##construct Identification list and datum
  
  start_date <- as.Date.character(t1)
  end_date <- as.Date.character(t2)
  
  ## list unique identifiers
  
  Identifiers <- unique(Swainsons_STC_Data_1995.df$Identifier)
  
  print(paste("Identifiers List: total =",length(Identifiers)))
  print(Identifiers)
  
  ## create list containing calendar dates of interest
  
  Movement_Calendar <-
    seq.Date(from = start_date,to = end_date,by = 1)
  
  print(paste("Number of days being analysed =", length(Movement_Calendar)))
  
  ## construct neccscary list objects
  
  lon.list <- c()
  lat.list <- c()
  Identifier.names <- c()
  TimeDates <- c()
  
  ## loop calculating the average lat/lon for each individual per unique date
  
  for (i in 1:length(Identifiers)) {
    ## select individual
    
    dataframe.individual <-
      dataframe[dataframe$Identifier == Identifiers[i],]
    
    ## loop through movement calendar
    
    for (j in 1:length(Movement_Calendar)) {
      ## check for movement dates matching dates in the movement calendar
      
      Truecheck <-
        dataframe.individual$TimeDate == Movement_Calendar[j]
      
      if (length(Truecheck[Truecheck == "TRUE"]) > 0) {
        ## select rows matching the movement calendar date of interest if present
        
        dataframe.individual.selection <-
          dataframe.individual[dataframe.individual$TimeDate == Movement_Calendar[j],]
        
        
        ## construct neccescary list objects and empty when looped
        
        x.list <- c()
        y.list <- c()
        z.list <- c()
        
        ## for each specific record (row) run it through the geocentre calc pt 1
        
        for (k in 1:nrow(dataframe.individual.selection)) {
          CurrentRecord <- dataframe.individual.selection[k,]
          
          lon00 <- CurrentRecord$Lon
          lat00 <- CurrentRecord$Lat
          
          xyzvalues <- geocentrecalcPt1(lon = lon00,lat = lat00)
          
          x.list <- append(x.list,xyzvalues[1])
          y.list <- append(y.list,xyzvalues[2])
          z.list <- append(z.list,xyzvalues[3])
          
        }
        
        
        ## run collected points through the geocentre calc pt 2
        
        latlonvalues <- geocentrecalcPt2(x.list,y.list,z.list)
        
        ## append outputted lon,lat as well as identifier and date to relevant lists
        
        lon.list <- append(lon.list,latlonvalues[1])
        lat.list <- append(lat.list,latlonvalues[2])
        Identifier.names <- append(Identifier.names,Identifiers[i])
        TimeDates <- append(TimeDates,Movement_Calendar[j])
        
        
        
      }
    }
    
  }
  
  ##construct a dataframe from the completed lists
  
  Individual_mean_tracks.df <-
    data.frame(
      lat.list,lon.list,Identifier.names,
      TimeDates,check.names = T,check.rows = T,
      stringsAsFactors = F
    )
}

## check dataframe output as neccescary

head(Individual_mean_tracks.df)
