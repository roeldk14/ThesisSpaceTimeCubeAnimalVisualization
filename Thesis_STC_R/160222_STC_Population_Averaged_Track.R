### STC_Population_Averaged_Track_Calculator_Script Space_Time_Cube_Animal_Visualization
### 22\02\16

### Calculates the population average track from multiple individuals for a given dataset

Population_Averaged_Track_Calculator <- function(dataframe,t1,t2, identifier.name) {
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
  
  ## Create unique identifier
  
  Identifier <- identifier.name
  
  print(paste("unique identifer =",(Identifier)))
  
  ## create list containing calendar dates of interest
  
  Movement_Calendar <-
    seq.Date(from = start_date,to = end_date,by = 1)
  
  print(paste("Number of days being analysed =", length(Movement_Calendar)))
  
  ## construct neccscary list objects
  
  lon.list <- c()
  lat.list <- c()
  Identifier.names <- c()
  TimeDates <- c()
  
