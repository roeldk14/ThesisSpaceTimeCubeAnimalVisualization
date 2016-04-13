### STC_External_Object_Bulider_And_Visualizer_Script  Space_Time_Cube_Animal_Visualization 
### 16\02\16 

### Construction of STC objects for External visualization ## Function left unfinshed due to limitations of KML visualization

## Create STC sp pathway objects (lines)

  dataframe2 <- STC_Animal_Movement_Individuals.List.df$SW1
  xy <- data.frame(dataframe2$long,dataframe2$lat)
  spdf <- SpatialPointsDataFrame(coords = xy, data = dataframe2, proj4string = CRS(proj))

       kml(current.STIDF,filename = "Thesis_STC_Output/testkmlSW.kml",extrude = TRUE, altitude = dataframe2$Days_Count*100,kmz = TRUE,altitudeMode = "relativeToGround ")

       
       PolyLines2GE(coords = xy,maxAlt = dataframe2$Days_Count*1000,goo = "Thesis_STC_Output/lines2g_sw.kml",colors = "auto",extrude = 1,fill = F,closepoly = F,lwd = 2)
    
