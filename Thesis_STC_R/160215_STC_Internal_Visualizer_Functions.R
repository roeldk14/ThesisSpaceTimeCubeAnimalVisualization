### STC_Internal_Visualizer_Functions_Script  Space_Time_Cube_Animal_Visualization
### 15\02\16

### STC Visulization Functions from the RGL package and others specifically for internal analysis
### on the R platform


STC_Internal_Track_Visualizer <-
  function(dataframe,STC_Title = "STC_Visualization",symbol_l.p.s = "p", add = FALSE,Color = as.numeric(as.factor(dataframe$Identifier))) {
    ## visualization of tracks and coordinates using plot3D
    
    plot3d(
      dataframe$long,dataframe$lat,dataframe$TimeDate, xlim =
        range(dataframe$long), ylim = range(dataframe$lat),
      zlim = range(dataframe$TimeDateNumeric), ticktype =
        "detailed", xlab = "longitude", ylab = "latitude",
      zlab = "Date",col = Color, type =
        symbol_l.p.s, add = add, main = STC_Title
    )
  }

## visualization of KDE home ranges using plot3D

STC_Internal_KDE_Visualizer <-
  function(dataset.kde, colors = c("gray","blue"),drawpoints = FALSE, add = TRUE,STC_Title = "STC_Visualization") {
    plot(
      dataset.kde,cont = c(50,95),colors = colors, drawpoints = drawpoints, xlab = "long", ylab = "lat",
      zlab = "time", size = 2, ptcol = "white", add = add, box = TRUE, axes = TRUE, main = STC_Title
    )
  }


# function() {
#   identify3d(x = xyzanimal.matrix, labels = STC_Animal_Movement_time_period_subset.df$Identifier,plot = TRUE)
# }
# 
# 
# text3d(xyz)
# 
