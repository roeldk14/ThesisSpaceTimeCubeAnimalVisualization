### STC_Internal_Visualizer_Functions_Script  Space_Time_Cube_Animal_Visualization
### 15\02\16

### STC Visulization Functions from the RGL package and others specifically for internal analysis
### on the R platform

## STC visualization setup using plot3d

STC_Internal_Visualization_Setup <-
  function(dataframe,
           STC_Title = NULL,
           subtitle = NULL,
           add = FALSE,
           proj = "LL") {
    if (proj == "LL") {
      plot3d(
        0,
        0,
        0,
        xlim = range(dataframe$long),
        ylim = range(dataframe$lat),
        zlim = range(dataframe$Days_Count),
        xlab = NULL,
        ylab = NULL,
        zlab = NULL,
        ticktype = "detailed",
        add = add
      )
      decorate3d(
        xlab = "Longitude",
        ylab = "latitude",
        zlab = "Days",
        box = TRUE,
        axes = TRUE,
        main = STC_Title,
        sub = subtitle,
        top = TRUE,
        expand = 1.05,
        col.lab = "red",
        cex.lab = "1.5"
      )
    }
    if (proj == "UTM") {
      plot3d(
        0,
        0,
        0,
        xlim = range(dataframe$UTM.East),
        ylim = range(dataframe$UTM.North),
        zlim = range(dataframe$Days_Count),
        xlab = NULL,
        ylab = NULL,
        zlab = NULL,
        ticktype = "detailed",
        add = add
      )
      decorate3d(
        xlab = "Easting",
        ylab = "Northing",
        zlab = "Date",
        box = TRUE,
        axes = TRUE,
        main = STC_Title,
        sub = subtitle,
        top = TRUE,
        expand = 1.05,
      )
      bgplot3d({
        plot.new()
        title(main = STC_Title, line = 3)
        mtext(side = 1, subtitle, line = 4)
      })
      
    }
    warning("proj must equal either 'LL' for Lat/Long or 'UTM' for Universal Transverse Mercator")
  }

########################################################################################
########################################################################################

## visualization of points,lines or spheres using plot3d

STC_Internal_Point_Line_Sphere_Visualizer <-
  function(dataframe,
           x,
           y,
           z,
           Type = "p",
           color = as.numeric(as.factor(dataframe$Identifier)),
           add = TRUE,
           size = 5,
           shapesize = 0.5,
           radius = 2,
           ...) {
    if (Type == "point" | Type == "line" | Type == "sphere" | Type == "tetra" | Type == "cube" | Type == "sprite") {
      if (Type == "point") {
        points3d(x,
                 y,
                 z,
                 color = color,
                 add = add,
                 size = size,
                 ...)
      }
      if (Type == "line") {
        lines3d(x, y, z, color = color, add = add, ...)
      }
      if (Type == "sphere") {
        spheres3d(x,
                  y,
                  z,
                  color = color,
                  add = add,
                  radius = radius,
                  ...)
      }
      if (Type == "tetra") {
        shapelist3d(tetrahedron3d(), x, y, z, size =  shapesize, 
                    color = color, add = add, ...)
      }
      if (Type == "cube") {
        shapelist3d(cube3d(), x, y, z, size =  shapesize, 
                    color = color, add = add, ...)
      }
      if (Type == "sprite") {
        sprites3d(x, y, z, color = color, add = add, ...)
      }
    }
    warning("Type must equal 'point' or 'line' or 'sphere' or 'tetra' for tetrahedron or 'cube' or 'sprite' ")
  }

########################################################################################
########################################################################################

## visualization of KDE home ranges using plot3d

STC_Internal_KDE_Visualizer <-
  function(dataset.kde,
           colors = c("gray", "blue"),
           drawpoints = FALSE,
           add = TRUE,
           ...) {
    plot(
      dataset.kde,
      cont = c(50, 95),
      colors = colors,
      drawpoints = drawpoints,
      xlab = "long",
      ylab = "lat",
      zlab = "time",
      size = 2,
      ptcol = "white",
      add = add,
      ...
    )
  }

########################################################################################
########################################################################################

## select points of interest from within a visualized scene

STC_Identify3d <- function(visualized_dataframe, proj = "LL") {
  if (proj == "LL") {
    xyzanimal.matrix <-
      matrix(
        c(
          visualized_dataframe$long,
          visualized_dataframe$lat,
          visualized_dataframe$Days_Count
        ),
        ncol = 3
      )
    identify3d(x = xyzanimal.matrix,
               labels = visualized_dataframe$Identifier,
               plot = TRUE)
  }
  if (proj == "UTM") {
    xyzanimal.matrix <-
      matrix(
        c(
          visualized_dataframe$UTM.East,
          visualized_dataframe$UTM.North,
          visualized_dataframe$Days_Count
        ),
        ncol = 3
      )
    identify3d(x = xyzanimal.matrix,
               labels = visualized_dataframe$Identifier,
               plot = TRUE)
  }
  warning("proj must equal either 'LL' for Lat/Long or 'UTM' for Universal Transverse Mercator")
}

########################################################################################
########################################################################################

## retreive selected points of interest from within a dataset based on their location

STC_Point_Retriever <- function(dataframe, point_locations) {
  selectedpoints.df <- data.frame()
  for (i in 1:length(point_locations)) {
    dataframesubset <- dataframe[point_locations[i],]
    selectedpoints.df <- rbind(selectedpoints.df, dataframesubset)
  }
  return(selectedpoints.df)
}

########################################################################################
########################################################################################

STC_add_point_info <-
  function(dataframe_being_visualized,
           chosen_dataframe_column) {
    text3d(
      x = dataframe_being_visualized$long,
      y = dataframe_being_visualized$lat,
      z = dataframe_being_visualized$Days_Count,
      texts = chosen_dataframe_column,
      adj = c(1.25, 1.25)
    )
  }

########################################################################################
########################################################################################


##: Add a 2d visualization of the data to the scene

STC_2D_Background_Visualization <-
  function(map, points, outliers = NULL, interactions = NULL,colP = "red", colO = "yellow", colI = "Green",title,subtitle,coltext = "white") {
    subfun <- function(map, points, outliers = NULL, interactions = NULL,colP = "red", colO = "yellow", colI = "Green",title,subtitle,coltext = "white") {
      plot(map, raster = TRUE)
      points(points$long, points$lat, col = colP)
      points(outliers$long,outliers$lat, col = colO, pch = 4)
      points(interactions$long,interactions$lat, col = colI, pch = 8)
      title(main = title, line = 0, col.main = coltext, cex.main = 2)
      mtext(side = 1, subtitle, line = 1, col = coltext, cex = 1.5)
    }
    bgplot3d(subfun(map, points, outliers, interactions,colP, colO, colI,title,subtitle,coltext))
  }

########################################################################################
########################################################################################

##: add static titles and a 2d visualization to the scene

STC_Static_Titles <- function(title, subtitle,coltext = "black") {
  subfun <- function(title,subtitle, coltext = "black") {
    plot.new()
    title(main = title, line = 3, col.main = coltext, cex.main = 2)
    mtext(side = 1, subtitle, line = 4, col = coltext, cex = 1.5)
  }
  bgplot3d(subfun(title,subtitle,coltext = "black"))
}

########################################################################################
########################################################################################

##: Create subset of datapoints so as to provide date info

Sequence_Date_points <- function(dataframe, time_interval = 30) {
  
  days = 0
  
  newdataframe <- dataframe[0,]
  
  while (days < max(dataframe$Days_Count)) {
    
    location <-
      which.min(abs(dataframe$Days_Count - days))
    
    newdataframe <- rbind(newdataframe,dataframe[location,])
    
    days = days + time_interval
  }
  return(newdataframe)
}
