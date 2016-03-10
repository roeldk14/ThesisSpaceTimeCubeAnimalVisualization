### STC_Internal_Visualizer_Functions_Script  Space_Time_Cube_Animal_Visualization
### 15\02\16

### STC Visulization Functions from the RGL package and others specifically for internal analysis
### on the R platform

## STC visualization setup using plot3d

STC_Internal_Visualization_Setup <-
  function(dataframe,
           STC_Title = "STC_Visualization",
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
        zlim = range(dataframe$TimeDateNumeric),
        xlab = NULL,
        ylab = NULL,
        zlab = NULL,
        ticktype = "detailed",
        add = add
      )
      decorate3d(
        xlab = "Longitude",
        ylab = "latitude",
        zlab = "Date",
        box = TRUE,
        axes = TRUE,
        main = STC_Title,
        sub = subtitle,
        top = TRUE,
        expand = 1.05
      )
    }
    if (proj == "UTM") {
      plot3d(
        0,
        0,
        0,
        xlim = range(dataframe$UTM.East),
        ylim = range(dataframe$UTM.North),
        zlim = range(dataframe$TimeDateNumeric),
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
        expand = 1.05
      )
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
           radius = 2,
           ...) {
    if (Type == "p" | Type == "l" | Type == "s" | Type == "sp") {
      if (Type == "p") {
        points3d(x,
                 y,
                 z,
                 color = color,
                 add = add,
                 size = size,
                 ...)
      }
      if (Type == "l") {
        lines3d(x, y, z, color = color, add = add, ...)
      }
      if (Type == "s") {
        spheres3d(x,
                  y,
                  z,
                  color = color,
                  add = add,
                  radius = radius,
                  ...)
      }
      if (Type == "sp") {
        sprites3d(x, y, z, color = color, add = add, ...)
      }
    }
    warning("Type must equal 'p' for point or 'l' for line or 's' for sphere or 'sp' for sprite")
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
          visualized_dataframe$TimeDateNumeric
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
          visualized_dataframe$TimeDateNumeric
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
      z = dataframe_being_visualized$TimeDateNumeric,
      texts = chosen_dataframe_column,
      adj = c(1.25, 1.25)
    )
  }

########################################################################################
########################################################################################

STC_2D_Background_Visualization <-
  function(map, x, y, col = "red") {
    subfun <- function(map, x, y, col) {
      plot(map, raster = TRUE)
      points(x, y, col = col)
    }
    bgplot3d(subfun(map, x, y, col))
  }
