### STC_Averaged_Pathway_Calculator_Script Space_Time_Cube_Animal_Visualization 
### 16\02\16

### Calculates the population or averages pathway of multiple individuals from a given dataset

Averaged_Pathway_Calculator <- function(Dataset) {}

geocentrecalcPt1 <- function(lat,lon) {

  ## calculating a central geo point part 1
  ## convert to cartesian coordinates
  lat1 <- lat * pi/180
  lon1 <- lon * pi/180
  
  x1 <- cos(lat1) * cos(lon1)
  y1 <- cos(lat1) * sin(lon1)
  z1 <- sin(lat1)
  
  return(c(x1,y1,z1))
}

geocentrecalcPt2 <- function(xlist,ylist,zlist) {
  
  ## calculating a central geo point part 2
  
  ## calculate average x, y and z coordinates
  x <- mean(x.list)
  y <- mean(y.list)
  z <- mean(z.list)
  
  lon <- atan2(y,x)
  hyp <- sqrt(x * x + y * y)
  lat <- atan2(z,hyp)
  
  lat <- lat * 180 / pi
  lon <- lon * 180 / pi
  
  return(c(lat,lon))
  
}

##construct Identification list and datum 

start_date <- as.Date.character("1995-01-01")
end_date <- as.Date.character("1995-12-31")

Identifiers <-unique(Swainsons_STC_Data_1995.df$Identifier)

## display identifiers
Identifiers

## create movement claendar
Movement_Calendar <- seq.Date(from = start_date,to = end_date,by = 1)
head(Movement_Calendar)

lon.list <- c()
lat.list <- c()
Identifier.names <- c()
TimeDates <- c()

for (i in 1:length(Identifiers)) {
  SW.Individual.df <-
    Swainsons_STC_Data_1995.df[Swainsons_STC_Data_1995.df$Identifier == Identifiers[i],]
  
  for (j in 1:length(Movement_Calendar)) {
    Truecheck <- SW.Individual.df$TimeDate == Movement_Calendar[j]
    
    if (length(Truecheck[Truecheck == "TRUE"]) > 0) {
      SW.Individual.Selection.df <-
        SW.Individual.df[SW.Individual.df$TimeDate == Movement_Calendar[j],]
      
      x.list <- c()
      y.list <- c()
      z.list <- c()
      
      for (k in 1:nrow(SW.Individual.Selection.df)) {
        CurrentRecord <- SW.Individual.Selection.df[k,]
        
        lat00 <- CurrentRecord$Lat
        lon00 <- CurrentRecord$Lon
        
        xyzvalues <- geocentrecalcPt1(lat = lat00,lon = lon00)
        
        x.list <- append(x.list,xyzvalues[1])
        y.list <- append(y.list,xyzvalues[1])
        z.list <- append(z.list,xyzvalues[1])
        
      }
      
      
      latlonvalues <- geocentrecalcPt2(x.list,y.list,z.list)
      
      lat.list <- append(lat.list,latlonvalues[1])
      lon.list <- append(lon.list,latlonvalues[2])
      Identifier.names <- append(Identifier.names,Identifiers[i])
      TimeDates <- append(TimeDates,Movement_Calendar[j])
      
    }
  }
  
} 

