### STC_KDE_Calculator_Script Space_Time_Cube_Animal_Visualization
### 16\02\16

### Calculate a KDE for a specified dataset in both time and space

STC_KDE_Calculator <- function(dataframe,proj = "LL") {
  if (proj == "LL") {
    xyzanimal.matrix <-
      matrix(data = c(dataframe$long,dataframe$lat,dataframe$TimeDate),ncol = 3)
  }
  if (proj == "UTM") {
    xyzanimal.matrix <-
      matrix(data = c(as.numeric(dataframe$UTM.East),as.numeric(dataframe$UTM.North),as.numeric(dataframe$TimeDate)),ncol = 3)
  }
  warning("proj must equal either 'LL' for Lat/Long or 'UTM' for Universal Transverse Mercator")
  H.pi <- Hpi(xyzanimal.matrix,binned = TRUE)
  
  xyzanimal.kde <- kde(xyzanimal.matrix, H.pi)
  
}
