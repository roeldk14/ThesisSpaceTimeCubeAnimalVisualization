### Movebank_CSV File Cleaner Script Space_Time_Cube_Animal_Visualization 
### 15\02\16 



Movebank_CSV_FileLoader <- function(CSV_File) {}

## open CSV file

Swainsons_Data <- read.csv(file = "Thesis_STC_Data/Swainson's Hawks.csv",stringsAsFactors = FALSE)

## retrieve data columns of interest

Lon <- Swainsons_Data$location.long
Lat <- Swainsons_Data$location.lat

####### currently removing Hours,minutes and seconds (consider later)

TimeDate <- as.Date(Swainsons_Data$timestamp)
TimeDateNumeric <- as.numeric(timeDate)
Identifier <- Swainsons_Data$individual.local.identifier
UTM.East <- Swainsons_Data$utm.easting
UTM.North <- Swainsons_Data$utm.northing
TimezoneLocal <- Swainsons_Data$study.timezone
TimeDateLocal <- as.Date(Swainsons_Data$study.local.timestamp)
TimeDateLocalNumeric <- as.numeric(TimeDateLocal)


## recreate dataframe with relevant columns

Swainsons_STC_Data <- data.frame("Lon" = Lon, "Lat" = Lat, "TimeDate" = TimeDate, "TimeDateNumeric" = TimeDateNumeric,
                                 "Identifier" = Identifier, "UTM.East" = UTM.East, "UTM.North" = UTM.North,
                                 "TimezoneLocal" = TimezoneLocal, "TimeDateLocal" = TimeDateLocal, "TimeDateLocalNumeric" = TimeDateLocalNumeric)


## check data columns and new data frame

head(TimeDate)
head(TimeDateNumeric)
head(Swainsons_STC_Data)


## break down into years






plottitle <- "Swainsons_Hawk_Test"

plot3d(lon,lat,TimeDate, xlim=range(lon), ylim=range(lat), 
       zlim=range(TimeDateNumeric), ticktype="detailed", xlab="longitude", ylab="latitude", 
       zlab="Date",col = as.numeric(Swainsons_STC_Data$Identifier), type="l", main=plottitle)

help("plot3D")
