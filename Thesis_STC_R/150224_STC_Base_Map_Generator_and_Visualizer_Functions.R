### STC_Base_Map_Generator_and_Visualizer_Script  Space_Time_Cube_Animal_Visualization
### 24\02\16

### Function to retrieve a base map using the OpenStreetMap package

STC_Base_Map_Generator <-
  function(dataset, Zoom = NULL, Type = "bing", MergeTiles = TRUE, Title = "Test",projection = "+proj=longlat") {
    ## Retrieve Upper Left / Lower Right lat and long
    
    UpperLeft <- c(max(dataset$lat),min(dataset$long))
    ifelse(UpperLeft[1] <= 80, UpperLeft [1] <- UpperLeft[1] +10,UpperLeft[1] <- 90)
    ifelse(UpperLeft[2]  <= 170, UpperLeft[2] <- UpperLeft[2]-10, UpperLeft[2] <- 180) 

    LowerRight <- c(min(dataset$lat),max(dataset$long))
    ifelse(LowerRight[1] >= -80, LowerRight[1] <- LowerRight[1] -10, LowerRight[1] <- -90) 
    ifelse(LowerRight[2] >= -170, LowerRight[2] <- LowerRight[2] + 10, LowerRight[2] <- -180) 

    print("Bounding Box + 5 Lat/Long Boundary =")
    print(paste("Upper Left Lat/Long =",UpperLeft[1],",",UpperLeft[2]))
    print(paste("Lower Right Lat/Long =",LowerRight[1],",",LowerRight[2]))
    
    ## retrieve the open map
    
    datamap <-
      openmap(
        upperLeft = UpperLeft,lowerRight = LowerRight,zoom = Zoom,type = Type, mergeTiles = MergeTiles
      )
    
    datamap <- openproj(datamap, projection = "+proj=longlat")
    
    plot(datamap,raster = T,main = paste(Title, "test visualization"))
    
    return(datamap)
    
  }

### Function to add a z value to an OSM map and visualize it

### All thanks and rights for the original script "map3d" go to StackOverLoader (Spacedman)

STC_Base_Map_3d_Visualizer  <- function(map, dataset, zvalue = 0, ...) {
  if (length(map$tiles) != 1) {
    stop("multiple tiles not implemented")
  }
  if (zvalue == 0) {
    zvalue <- min(dataset$TimeDateNumeric)
  }
  nx = map$tiles[[1]]$xres
  ny = map$tiles[[1]]$yres
  xmin = map$tiles[[1]]$bbox$p1[1]
  xmax = map$tiles[[1]]$bbox$p2[1]
  ymin = map$tiles[[1]]$bbox$p1[2]
  ymax = map$tiles[[1]]$bbox$p2[2]
  xc = seq(xmin,xmax,len = ny)
  yc = seq(ymin,ymax,len = nx)
  colours = matrix(map$tiles[[1]]$colorData,ny,nx)
  m = matrix(zvalue,ny,nx)
  surface3d(xc,yc,m,col = colours, ...)
}
