### STC_Averaged_Pathway_Calculator_Script Space_Time_Cube_Animal_Visualization 
### 16\02\16

### Calculates the population or averages pathway of multiple individuals from a given dataset

Averaged_Pathway_Calculator <- function(Dataset) {}

head(Swainsons_STC_Data_1995.df)

##construct Identification list

start_date <- as.Date.character("1995-01-01")
end_date <- as.Date.character("1995-12-31")
Identifier_list <-list(unique(Swainsons_STC_Data_1995.df$Identifier))
head(Identifier_list)
Movement_Calendar <- seq.Date(from = start_date,to = end_date,by = 1)
head(Movement_Calendar)
listlon <- double()
listlat <- double()
listidentifier <- double()
listdate <- double()

for (i in Identifier_list) {
  SW.df <- Swainsons_STC_Data_1995.df[Swainsons_STC_Data_1995.df$Identifier == i,]
  
  for (j in Movement_Calendar) {
    
    for (k in length(SW.df$TimeDate)) {
      
      if (SW.df$TimeDate == j) {
        
        doublex <- double()
        doubley <- double()
        doublez <- double()
        
        CurrentRecord <- SW.df[SW.df$TimeDate == j,]
        
        for (k in length(CurrentRecord)) {
          
          lat00 <- CurrentRecord$Lat[k]
          lon00 <- CurrentRecord$Lon[k]
          
          lat1 <- lat00 * pi/180
          lon1 <- lon00 * pi/180
          
          x1 <- cos(lat1) * cos(lon1)
          y1 <- cos(lat1) * sin(lon1)
          z1 <- sin(lat1)
          
          doublex <- c(doublex,x1)
          doubley <- c(doubley,y1)
          doublez <- c(doublez,z1)
          
          x <- (sum(doublex))/(length(CurrentRecord))
          y <- (sum(doubley))/(length(CurrentRecord))
          z <- (sum(doublez))/(length(CurrentRecord))
          
          lon <- atan2(y,x)
          hyp <- sqrt(x*x+y*y)
          lat <- atan2(z,hyp)
          
          lat <- lat * 180/pi
          lon <- lon * 180/pi
          
          listlat <- c(listlat,lat)
          listlon <- c(listlon,lon)
          listidentifier <- c(listidentifier,Identifier_list[i])
          listdate <- c(listdate,Movement_Calendar[j])
       }
      }
    }
      
} 
}

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
