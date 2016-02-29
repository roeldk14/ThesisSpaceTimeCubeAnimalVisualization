### Master_Script Space_Time_Cube_Animal_Visualization
### 26\01\16

### check working directory

getwd()

### If required change directory

# setwd()

### Install required packages

# install.packages("SpatialEpi")
# install.packages("ks")
# install.packages("zoom")
# install.packages("geotools")
# install.packages("rgdal")
# install.packages("sp")
# install.packages("rgeos")
# install.packages("ggplot2")
# install.packages("rgl")
# install.packages("dismo")
# install.packages("XML")
# install.packages("OpenStreetMap")
# install.packages("spatstat")
### Load Libraries

#library("SpatialEpi")
library("ks")
#library("zoom")
#library("geotools")
#library("rgeos")
library("rgdal")
library("sp")
library("ggplot2")
library("rgl")
#library("dismo")
#library("XML")
library("OpenStreetMap")
library("spatstat")

### Load Functions

source("Thesis_STC_R/160215_STC_movebank_CSV_to_dataframe.R")
source("Thesis_STC_R/160216_STC_Time_Period_Selector.R")
source("Thesis_STC_R/160222_STC_Geocentre_Midpoint_Calculator.R")
source("Thesis_STC_R/160216_STC_Individual_Averaged_Tracks.R")
source("Thesis_STC_R/160222_STC_Population_Averaged_Track.R")
source("Thesis_STC_R/160216_STC_KDE_Calculator.R")
source("Thesis_STC_R/160215_STC_Internal_Visualizer_Functions.R")
source("Thesis_STC_R/150224_STC_Base_Map_Addition_Script.R")

#Source("R/")

### Open CSV file and write to DF

STC_Animal_Movement.df <-
  STC_Movebank_CSVtoDF("Thesis_STC_Data/Swainson's Hawks.csv")

### Investigate data

head(STC_Animal_Movement.df)
typeof(STC_Animal_Movement.df$Identifier[1])

###################################################################
### Set parameters of interest

## Time period of interest

t1 <- "1995-01-01"
t2 <- "1995-12-31"

## Identifier

Identifier <- "SW"

## STC_Title

STC_Title <- "Swainsons Hawk Test Initial Visualization"

boundingbox <-
  bounding.box.xy(x = STC_Animal_Movement.df$long,y = STC_Animal_Movement.df$lat)

## Select Cordinate Projection

Projection <- ""

## Lat Long Projection

Projection_LatLong <- "+proj=longlat"

###################################################################

### Subset time period of interest

STC_Animal_Movement_time_period_subset.df <-
  STC_time_period_selector(STC_Animal_Movement.df,t1,t2)

head(STC_Animal_Movement_time_period_subset.df)

### Calculate Individual Averaged Tracks

Individual_Averaged_Animal_Movement_Tracks.df <-
  STC_Individual_Averaged_Tracks_Calculator(STC_Animal_Movement_time_period_subset.df,t1,t2)

head(Individual_Averaged_Animal_Movement_Tracks.df)


### Calculate Population Averaged Track

Population_Averaged_Track.df <-
  STC_Population_Averaged_Track_Calculator(Individual_Averaged_Animal_Movement_Tracks.df,t1,t2,Identifier)

head(Population_Averaged_Track.df)

### calculate KDE for a chosen animal dataset

STC_Animal_Movement_KDE <-
  STC_KDE_Calculator(STC_Animal_Movement_time_period_subset.df)


### Visualize the STC Track data internally for exploratorary data analysis

STC_Internal_Track_Visualization <-
  STC_Internal_Track_Visualizer(
    Population_Averaged_Track.df,STC_Title =
      STC_Title,symbol_l.p.s = "l",add = T
  )

### Visualize the STC KDE data internally for exploratorary data analysis

STC_Internal_KDE_Visualization <-
  STC_Internal_KDE_Visualizer(
    STC_Animal_Movement_KDE,
    colors = c("red","green"),drawpoints = T, add = T, STC_Title = STC_Title
  )

### Generate a Basemap

STC_Base_Map <- STC_Base_Map_Generator(
  STC_Animal_Movement.df, Zoom = NULL, Type = "bing",MergeTiles = TRUE,Title = STC_Title,projection = Projection_LatLong
)

### Visualize the Base Map in 3d

STC_3d_Base_Map <- STC_Base_Map_3d_Visualizer(STC_Base_Map,STC_Animal_Movement.df,zvalue = 1)

###################################################################


rgl.open()    #: Opens a new device
rgl.close()   #: Closes the current device
rgl.clear()   #: Clears the current device
rgl.cur()     #: Returns the active device ID
rgl.quit()    #: Shutdowns the RGL device system

###################################################################

######The function writeWebGL() is used to write the current scene to HTML:

rgl.snapshot(fmt = "png",filename = "Thesis_STC_Output/Test_Plot_Initial_Visualization")

rgl.surface()