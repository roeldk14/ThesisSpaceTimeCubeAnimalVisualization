### STC_Geocentre_Calculator_Script Space_Time_Cube_Animal_Visualization
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
