### STC_Time_Period_Subsetter_Script Space_Time_Cube_Animal_Visualization 
### 16/02/16

### Selects Period of interest to the user for later visualization or manipulation

## Select specific period of interest


STC_time_period_selector <- function(dataframe,t1,t2) {
  
  ## test for correctly inputted date format
  
  testt1 <- grep("[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]", t1)
  testt2 <- grep("[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]", t2)
  
  if (any(isTRUE(all.equal(testt1,integer(0))) == TRUE |
          isTRUE(all.equal(testt2,integer(0))) == TRUE))
    stop("t1 and t2 dates must be in format Year-Month-Date (1999-12-31)")
  
  ## Format as date
  
  t1 <- as.Date(t1)
  t2 <- as.Date(t2)
  
  ## subset data
  
  Time_subset_animal_data.df <-
    dataframe[dataframe$TimeDate %in% t1:t2,]
  
}

## check outputted dataframe as neccescary

head(Swainsons_STC_Data_1995.df)