### STC_Internal_Visualizer_Script  Space_Time_Cube_Animal_Visualization
### 15\02\16

### Visulization of STC using the RGL package specifically for analysis internally
### on the R platform


STC_Internal_Visualizer <- function(dataframe,STC_Title = "STC_Visualization",symbol_l.p.s = "p") {
  
  ## visualization using plot3D
  
  plot3d(
    dataframe$long,dataframe$lat,dataframe$TimeDate, xlim =
      range(dataframe$long), ylim = range(dataframe$lat),
    zlim = range(dataframe$TimeDateNumeric), ticktype =
      "detailed", xlab = "longitude", ylab = "latitude",
    zlab = "Date",col = as.numeric(as.factor(dataframe$Identifier)), type =
      symbol_l.p.s, main = STC_Title
  )
}

# ### For testing purposes
# 
# plottitle <- "Swainsons_Hawk_Test"
# 
# ## visualization using plot3D
# 
# plot3d(
#   Individual_Averaged_Animal_Movement_Tracks.df$long,Individual_Averaged_Animal_Movement_Tracks.df$lat,Individual_Averaged_Animal_Movement_Tracks.df$TimeDate, xlim =
#     range(Individual_Averaged_Animal_Movement_Tracks.df$long), ylim = range(Individual_Averaged_Animal_Movement_Tracks.df$lat),
#   zlim = range(Individual_Averaged_Animal_Movement_Tracks.df$TimeDateNumeric), ticktype =
#     "detailed", xlab = "longitude", ylab = "latitude",
#   zlab = "Date",col = as.numeric(as.factor(Individual_Averaged_Animal_Movement_Tracks.df$Identifier)), type =
#     "l", main = plottitle
# )
# 
# help("Plot3D")
