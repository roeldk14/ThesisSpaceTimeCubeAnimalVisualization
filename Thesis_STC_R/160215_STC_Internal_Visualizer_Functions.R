### STC_Internal_Visualizer_Functions_Script  Space_Time_Cube_Animal_Visualization
### 15\02\16

### STC Visulization Functions from the RGL package and others specifically for internal analysis
### on the R platform

dataframe <- STC_Animal_Movement_time_period_subset.df

## STC visualization setup using plot3d

STC_Internal_Visualization_Setup <-
  function(dataframe,STC_Title = "STC_Visualization",subtitle = NULL, add = FALSE) {
    plot3d( 
      0,0,0, xlim = range(dataframe$long),
      ylim = range(dataframe$lat), zlim = range(dataframe$TimeDateNumeric),
      xlab = NULL,ylab = NULL,zlab = NULL,
      ticktype = "detailed", add = add
    )
    decorate3d(
      xlab = "Longitude",ylab = "latitude",zlab = "Date",
      box = TRUE,axes = TRUE,main = STC_Title,sub = subtitle,top = TRUE,expand = 1.05
    )
  }

## visualization of points,lines or spheres using plot3d

STC_Internal_Point_Line_Sphere_Visualizer <- function(dataframe, Type = "p",color = as.numeric(as.factor(dataframe$Identifier)), add = TRUE, size = 5, radius = 0.5, ...) {
  if (Type == "p" | Type == "l" | Type == "s") {
    if (Type == "p") {
      rgl.points(x = dataframe$long, y = dataframe$lat, z = dataframe$TimeDateNumeric, color = color,add = add, size = size, ...)
    }
    if (Type == "l") {
      rgl.lines(x = dataframe$long, y = dataframe$lat, z = dataframe$TimeDateNumeric, color = color,add = add, ...)
    }
    if (Type == "s") {
      rgl.spheres(x = dataframe$long, y = dataframe$lat, z = dataframe$TimeDateNumeric, color = color,add = add,radius = radius, ...)
    }
  }
  warning("Type must equal 'p' for point or 'l' for line or 's' for sphere")
}



## visualization of KDE home ranges using plot3d

STC_Internal_KDE_Visualizer <-
  function(dataset.kde, colors = c("gray","blue"),drawpoints = FALSE, add = TRUE) {
    plot(
      dataset.kde,cont = c(50,95),colors = colors, drawpoints = drawpoints, xlab = "long", ylab = "lat",
      zlab = "time", size = 2, ptcol = "white", add = add, drawpoints = drawpoints
    )
  }

## select points of interest from within a visualized scene

STC_Identify3d <- function(visualized_dataframe) {
  xyzanimal.matrix <-
    matrix(c(dataframe$long,dataframe$lat,dataframe$TimeDateNumeric),ncol =
             3)
  identify3d(x = xyzanimal.matrix, labels = dataframe$Identifier,plot = TRUE)
}

## retreive selected points of interest from within a dataset based on their location

STC_Point_Retriever <- function(dataframe,point_locations) {
  selectedpoints.df <- data.frame()
  for (i in 1:length(point_locations)) {
    dataframesubset <- dataframe[point_locations[i],]
    selectedpoints.df <- rbind(selectedpoints.df,dataframesubset)
  }
  return(selectedpoints.df)
}


#text3d(xyz)
