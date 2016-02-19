### STC_Averaged_Pathway_Calculator_Script Space_Time_Cube_Animal_Visualization 
### 16\02\16

### Calculates the population or averages pathway of multiple individuals from a given dataset

Averaged_Pathway_Calculator <- function(Dataset) {}

##construct Identification list and datum 

start_date <- as.Date.character("1995-01-01")
end_date <- as.Date.character("1995-12-31")

Identifiers <-unique(Swainsons_STC_Data_1995.df$Identifier)

## display identifiers
Identifiers

## create movement claendar
Movement_Calendar <- seq.Date(from = start_date,to = end_date,by = 1)
head(Movement_Calendar)

lon.data <- c()
lat.data <- c()
identifier.data <- c()
date.data <- c()

i = 1

for (i in length(Identifiers)) {
  
  SW.df <- Swainsons_STC_Data_1995.df[Swainsons_STC_Data_1995.df$Identifier == Identifiers[i],]
  
  j = 230
  
  for (j in length(Movement_Calendar)) {
    
    x.list <- c()
    y.list <- c()
    z.list <- c()
    
    k = 1
    countk = 0
    
    for (k in length(SW.df$TimeDate)) {
      
      if (SW.df$TimeDate[k] == Movement_Calendar[j]) {
        
        CurrentRecord <- SW.df[k,]
          
        lat00 <- CurrentRecord$Lat
        lon00 <- CurrentRecord$Lon
          
        lat1 <- lat00 * pi/180
        lon1 <- lon00 * pi/180
          
        x1 <- cos(lat1) * cos(lon1)
        y1 <- cos(lat1) * sin(lon1)
        z1 <- sin(lat1)
          
        x.list <- c(x.list,x1)
        y.list <- c(y.list,y1)
        z.list <- c(z.list,z1)
        
        countk = countk + 1
      }
      
      k = k + 1
      
    } 
    
    x <- (sum(x.list)/countk)
    y <- (sum(y.list)/countk)
    z <- (sum(z.list)/countk)
    
    print(paste("count of matching dates",countk))
    
    lon <- atan2(y,x)
    hyp <- sqrt(x*x+y*y)
    lat <- atan2(z,hyp)
          
    lat <- lat * 180/pi
    lon <- lon * 180/pi
          
    lat.data <- c(lat.data,lat)
    lon.data <- c(lon.data,lon)
    identifier.data <- c(identifier.data,Identifiers[i])
    date.data <- c(date.data,Movement_Calendar[j])
    
    print(paste("current identifier",Identifiers[i]))
    print(paste("current date",Movement_Calendar[j]))
    
    print("repeat")
  
    j = j + 1
  
  }
  
  i = i + 1
  
} 

length(unique(SW.df$TimeDate))

SW1 <- subset(Swainsons_STC_Data_1995.df,Swainsons_STC_Data_1995.df$Identifier ==  "SW1")
SW3 <- subset(Swainsons_STC_Data_1995.df,Swainsons_STC_Data_1995.df$Identifier ==  "SW3")
head(SW1)
head(SW3)







lat01 <- Swainsons_STC_Data_1995.df$Lat[1]
lon01 <- Swainsons_STC_Data_1995.df$Lon[1]

## calculate midpoint

## convert to cartesian coordinates

lat1 <- lat01 * pi/180
lon1 <- lon01 * pi/180

x1 <- cos(lat1) * cos(lon1)
y1 <- cos(lat1) * sin(lon1)
z1 <- sin(lat1)

W1 <- 1

lat02 <- Swainsons_STC_Data_1995.df$Lat[2]
lon02 <- Swainsons_STC_Data_1995.df$Lon[2]

## calculate midpoint 

lat2 <- lat02 * pi/180
lon2 <- lon02 * pi/180

x2 <- cos(lat2) * cos(lon2)
y2 <- cos(lat2) * sin(lon2)
z2 <- sin(lat2)

W2 <- 1

## step 2 calculate weighted average x, y and z coordinates

W1 + W2

x <- ((x1*W1) + (x2 * W2))/2
y <- ((y1*W1) + (y2 * W2))/2
z <- ((z1*W1) + (z2 * W2))/2

lon <- atan2(y,x)
hyp <- sqrt(x*x+y*y)
lat <- atan2(z,hyp)

lat <- lat * 180/pi
lon <- lon * 180/pi

lat
lon

lat01
lon10
lat02
lon02
