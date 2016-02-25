### STC_Base_Map_Addition_Script  Space_Time_Cube_Animal_Visualization
### 24\02\16

### All thanks and rights for this script go to StackOverLoader (Spacedman) 

STC_Base_Map_Generator <- function(dataset)

dataset <- STC_Animal_Movement_time_period_subset.df  
Zoom = NULL
Type = c("osm", "osm-bw",
         "maptoolkit-topo", "waze", "mapquest", "mapquest-aerial", "bing",
         "stamen-toner", "stamen-terrain", "stamen-watercolor", "osm-german",
         "osm-wanderreitkarte", "mapbox", "esri", "esri-topo", "nps", "apple-iphoto",
         "skobbler", "cloudmade-<id>", "hillshade", "opencyclemap", "osm-transport",
         "osm-public-transport", "osm-bbike", "osm-bbike-german")
MergeTiles = TRUE

## Retrieve bounding box lat and long

LowerRight <- c(min(dataset$lat),min(dataset$long))
UpperLeft <- c(max(dataset$lat),max(dataset$long))
print(paste("Upper Left Lat/Long =",UpperLeft[1],",",UpperLeft[2]))
print(paste("Lower Right Lat/Long =",LowerRight[1],",",LowerRight[2]))

xlim <- c(UpperLeft[1],LowerRight[1])
ylim <- c(UpperLeft[2],LowerRight[2])

openmap(upperLeft = UpperLeft,lowerRight = LowerRight,zoom = Zoom,type = "bing", mergeTiles = MergeTiles)




map3d <- function(map, ...){
  if(length(map$tiles)!=1){stop("multiple tiles not implemented") }
  nx = map$tiles[[1]]$xres
  ny = map$tiles[[1]]$yres
  xmin = map$tiles[[1]]$bbox$p1[1]
  xmax = map$tiles[[1]]$bbox$p2[1]
  ymin = map$tiles[[1]]$bbox$p1[2]
  ymax = map$tiles[[1]]$bbox$p2[2]
  xc = seq(xmin,xmax,len=ny)
  yc = seq(ymin,ymax,len=nx)
  colours = matrix(map$tiles[[1]]$colorData,ny,nx)
  m = matrix(0,ny,nx)
  surface3d(xc,yc,m,col=colours, ...)
}




#http://spatial.ly/2013/05/3d-mapping-r/


