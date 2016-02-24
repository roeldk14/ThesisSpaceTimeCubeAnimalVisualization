### STC_Base_Map_Addition_Script  Space_Time_Cube_Animal_Visualization
### 24\02\16

### All thanks and rigths for this script go to StackOverLoader (Spacedman) 

openmap()




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


