### STC_KDE_Calculator_Script Space_Time_Cube_Animal_Visualization
### 16\02\16

### Calculate a KDE for a specified dataset in both time and space

STC_KDE_Calculator <- function(dataset) {
  xyzanimal.matrix <-
    matrix(data = c(dataset$long,dataset$lat,dataset$TimeDate),ncol = 3)
  
  H.pi <- Hpi(xyzanimal.matrix,binned = TRUE)
  
  xyzanimal.kde <- kde(xyzanimal.matrix, H.pi)
  
}
