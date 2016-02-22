### STC_Movebank_CSVtoDF_Writer_Script Space_Time_Cube_Animal_Visualization 
### 15\02\16 

### Opens CSV files and writes them out as a Dataframe Specifically aimed at Movebank Files


STC_Movebank_CSVtoDF <- function(CSV_File_Pathway) {
  
  ## open CSV file
  
  Animal_dataset <-
    read.csv(file = CSV_File_Pathway,stringsAsFactors = F)
  
  ## retrieve data columns of interest
  
  Lon <- Animal_dataset$location.long
  Lat <- Animal_dataset$location.lat
  TimeDate <- as.Date(Animal_dataset$timestamp)
  TimeDateNumeric <- as.numeric(TimeDate)
  Identifier <- Animal_dataset$individual.local.identifier
  UTM.East <- Animal_dataset$utm.easting
  UTM.North <- Animal_dataset$utm.northing
  TimezoneLocal <- Animal_dataset$study.timezone
  TimeDateLocal <- as.Date(Animal_dataset$study.local.timestamp)
  TimeDateLocalNumeric <- as.numeric(TimeDateLocal)
  
  ## recreate dataframe with relevant columns
  
  STC_animal_data.df <-
    data.frame(
      "long" = Lon, "lat" = Lat, "TimeDate" = TimeDate, "TimeDateNumeric" = TimeDateNumeric,
      "Identifier" = Identifier, "UTM.East" = UTM.East, "UTM.North" = UTM.North,
      "TimezoneLocal" = TimezoneLocal, "TimeDateLocal" = TimeDateLocal, "TimeDateLocalNumeric" = TimeDateLocalNumeric,stringsAsFactors = F
    )
  
}
## check data columns and new data frame
# typeof(Identifier[1])
# head(TimeDate)
# head(TimeDateNumeric)
# head(Swainsons_STC_Data.df$Identifier)
# typeof(Swainsons_STC_Data.df$Identifier[1])
