### STC_Internal_Visualizer_Script  Space_Time_Cube_Animal_Visualization 
### 15\02\16 

### Visulization of STC using the RGL package specifically for analysis internally 
### on the R platform 

STC_Internal_Visualizer <- function(Dataset,STC_Title) {}


plottitle <- "Swainsons_Hawk_Test"

## visualization using plot3D

plot3d(Swainsons_STC_Data_1995.df$Lon,Swainsons_STC_Data_1995.df$Lat,Swainsons_STC_Data_1995.df$TimeDate, xlim=range(Swainsons_STC_Data_1995.df$Lon), ylim=range(Swainsons_STC_Data_1995.df$Lat), 
       zlim=range(Swainsons_STC_Data_1995.df$TimeDateNumeric), ticktype="detailed", xlab="longitude", ylab="latitude", 
       zlab="Date",col = as.numeric(Swainsons_STC_Data_1995.df$Identifier), type="p", main=plottitle)



help("Plot3D")


