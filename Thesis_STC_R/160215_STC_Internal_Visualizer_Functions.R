### STC_Internal_Visualizer_Functions_Script  Space_Time_Cube_Animal_Visualization
### 15\02\16

### STC Visulization Functions from the RGL package and others specifically for internal analysis
### on the R platform


STC_Internal_Visualization_Setup <-
  function(dataframe,STC_Title = "STC_Visualization") {
    
    ## Open and intialise a new RGL scene
    ## from STHDA
    
    rgl_init <- function(new.device = FALSE, bg = "white", width = 640) { 
      if( new.device | rgl.cur() == 0 ) {
        rgl.open()
        par3d(windowRect = 50 + c( 0, 0, width, width ) )
        rgl.bg(color = bg )
      }
      rgl.clear(type = c("shapes", "bboxdeco"))
      rgl.viewpoint(theta = 15, phi = 20, zoom = 0.7)
    }
    
    ## rgl_add_axes(): A custom function to add x, y and z axes
    ## adapted from STHDA
    
    # x, y, z : numeric vectors corresponding to
    #  the coordinates of points
    # axis.col : axis colors
    # xlab, ylab, zlab: axis labels
    # show.plane : add axis planes
    # show.bbox : add the bounding box decoration
    # bbox.col: the bounding box colors. The first color is the
    # the background color; the second color is the color of tick marks
    
    rgl_add_axes <- function(x, y, z, axis.col = "black",
                             xlab = "latitude", ylab="longitude", zlab="Date/Time", show.plane = TRUE, 
                             show.bbox = TRUE, bbox.col = c("white","black"))
    { 
      
      lim <- function(x){c(-max(abs(x)), max(abs(x))) * 1.1}
      # Add axes
      xlim <- lim(x); ylim <- lim(y); zlim <- lim(z)
      rgl.lines(xlim, c(0, 0), c(0, 0), color = axis.col)
      rgl.lines(c(0, 0), ylim, c(0, 0), color = axis.col)
      rgl.lines(c(0, 0), c(0, 0), zlim, color = axis.col)
      
      # Add a point at the end of each axes to specify the direction
      axes <- rbind(c(xlim[2], 0, 0), c(0, ylim[2], 0), 
                    c(0, 0, zlim[2]))
      rgl.points(axes, color = axis.col, size = 3)
      
      # Add axis labels
      rgl.texts(axes, text = c(xlab, ylab, zlab), color = axis.col,
                adj = c(0.5, -0.8), size = 2)
      
      # Add plane
      if(show.plane) 
        xlim <- xlim/1.1; zlim <- zlim /1.1
      rgl.quads( x = rep(xlim, each = 2), y = c(0, 0, 0, 0),
                 z = c(zlim[1], zlim[2], zlim[2], zlim[1]))
      
      # Add bounding box decoration
      if(show.bbox){
        rgl.bbox(color=c(bbox.col[1],bbox.col[2]), alpha = 0.5, 
                 emission=bbox.col[1], specular=bbox.col[1], shininess=5, 
                 xlen = 3, ylen = 3, zlen = 3) 
      }
    }
    
    rgl_init()
    rgl_add_axes(x = dataframe$lat ,y = dataframe$long ,z = dataframe$TimeDateNumeric)
    
    
    ## visualization setup of the scene
  
    dataframe <- STC_Animal_Movement_time_period_subset.df
      
    plot3d(
      dataframe$long,dataframe$lat,dataframe$TimeDate, xlim =
        range(dataframe$long), ylim = range(dataframe$lat),
      zlim = range(dataframe$TimeDateNumeric), ticktype =
        "detailed", xlab = "longitude", ylab = "latitude",
      zlab = "Date",col = Color, type =
        symbol_l.p.s, add = add, main = STC_Title
    )
  }

plot3d(xlim = range(dataframe$long), ylim = range(dataframe$lat),
  zlim = range(dataframe$TimeDateNumeric), ticktype =
    "detailed", xlab = "longitude", ylab = "latitude",
  zlab = "Date", add = F, main = "test"
)
}

## addition of tracks and coordinates to the scene using sphere3d,line3d and point3d


color = as.numeric(as.factor(dataframe$Identifier))


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

STC_Initiate <- function(new.device = FALSE, bg = "white", width = 640) { 
  if( new.device | rgl.cur() == 0 ) {
    rgl.open()
    par3d(windowRect = 50 + c( 0, 0, width, width ) )
    rgl.bg(color = bg )
  }
  rgl.clear(type = c("shapes", "bboxdeco"))
  rgl.viewpoint(theta = 15, phi = 20, zoom = 0.7)
  rgl.bbox(xlim = range(dataframe$long), ylim = range(dataframe$lat),
           zlim = range(dataframe$TimeDateNumeric), ticktype = "detailed")
  rgl.texts(x = "longitude", y = "latitude",z = "Date")
}

rgl_init()
