### Master_Script Space_Time_Cube_Animal_Visualization
### 26\01\16

### The Space Time Cube Visualization Master Script and associated sub scripts
### together form the STC Visulaization "psuedo" package. The goal of the package
### or collection of functions is the simple and quick visualization of GPS tracking
### data in both space and time. It is aimed at allall users experienced or not.
### Visualization is internal for exploratory data analysis and external kml exports
### for data presentation. The Most accepted input data format is that of the files
### from MoveBank.org. I hope this Script is both useful and legible to you as the user.

########################################################################################
########################################################################################
########################################################################################

########################################################################################
### Set up working directory, install required packages, load required libraries,
### source functions and upload the dataset.

##: check working directory

getwd()

##: If required change directory

# setwd()

##: Install required packages

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

##: Load Libraries

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

##: Load Functions

source("Thesis_STC_R/160215_STC_movebank_CSV_to_dataframe.R")
source("Thesis_STC_R/160216_STC_Time_Period_Selector.R")
source("Thesis_STC_R/160222_STC_Geocentre_Midpoint_Calculator.R")
source("Thesis_STC_R/160216_STC_Individual_Averaged_Tracks.R")
source("Thesis_STC_R/160222_STC_Population_Averaged_Track.R")
source("Thesis_STC_R/160216_STC_KDE_Calculator.R")
source("Thesis_STC_R/160215_STC_Internal_Visualizer_Functions.R")
source("Thesis_STC_R/150224_STC_Base_Map_Generator_and_Visualizer_Functions.R")


##: Open CSV file and write to DF

##: (Open a chosen CSV file and write it to dataframe format (preferably from MoveBank.org))

STC_Animal_Movement.df <-
  STC_Movebank_CSVtoDF("Thesis_STC_Data/Swainson's Hawks.csv")

##: Investigate data

head(STC_Animal_Movement.df)

########################################################################################
########################################################################################
########################################################################################

########################################################################################
###set global parameters

##: Time period of interest

t1 <- "1995-01-01"
t2 <- "1995-12-31"

##: Summer Period

St1 <- "1995-05-01"
St2 <- "1995-09-30"

##: Winter Period

Wt1 <- "1995-11-01"
Wt2 <- "1996-02-29"

##: Identifier

Identifier <- "SW"

##: STC_Global_Title

STC_Title <- "Swainsons Hawk Test Initial Visualization"

boundingbox <-
  bounding.box.xy(x = STC_Animal_Movement.df$long,y = STC_Animal_Movement.df$lat)

##: Set Lat Long Projection

Projection_LatLong <- "+proj=longlat"

##: Select Cordinate Projection

Projection <- ""

########################################################################################
########################################################################################
########################################################################################

########################################################################################
### Prepare, transfrom and calculate the required data and objects for visualization

STC_Animal_Movement_time_period_subset.df <-
  ##: Subset time period of interest
  STC_time_period_selector(STC_Animal_Movement.df,t1,t2)

##: (subset from a given dataset the time period of interest)

head(STC_Animal_Movement_time_period_subset.df)

Individual_Averaged_Animal_Movement_Tracks.df <-
  ##: Calculate individual averaged tracks for a chosen dataset
  STC_Individual_Averaged_Tracks_Calculator(STC_Animal_Movement_time_period_subset.df,t1,t2)

##: (an average geographic coordinate is calcualted for each individual
##: on each day from all locations recorded on that day)

head(Individual_Averaged_Animal_Movement_Tracks.df)

Population_Averaged_Track.df <-
  ##: Calculate Population Averaged Track for a chosen animal dataset
  STC_Population_Averaged_Track_Calculator(Individual_Averaged_Animal_Movement_Tracks.df,t1,t2,Identifier)

##: (an average geographic coordinate is calcualted for each day from all locations recorded
##: on that day as long as n locations exceeds one, note: generally uses the individual tracks
##: function output )

head(Population_Averaged_Track.df)

STC_Animal_Movement_KDE <-
  ##: calculate KDE for a chosen animal dataset
  STC_KDE_Calculator(STC_Animal_Movement_time_period_subset.df)

##: (calculate the 95% and 50% kernel density estimate or home range from a given dataset)

########################################################################################
########################################################################################
########################################################################################

########################################################################################
### Generate internal STC visualizations for exploratory data anaylsis (initial visualization
### consists of the STC cube and basemap, any and all other additions are the users choice

##: Visualize the STC

##: (Construct and Visualize the Space Time Cube to the specifications of the dataset
##: being explored)

STC_Base_Map <- ##: Generate a Basemap
  STC_Base_Map_Generator(
    STC_Animal_Movement.df, Zoom = NULL, Type = "bing",MergeTiles = TRUE,Title = STC_Title,projection = Projection_LatLong
  )

##: (retrieve and generate a basemap using the openstreetmap function)

STC_3d_Base_Map <- ##: Visualize the Base Map within the STC
  STC_Base_Map_3d_Visualizer(STC_Base_Map,STC_Animal_Movement.df,zvalue = 9400,alpha = 1)

##: (add z values to a previosly retrieved OSM base map and visualize it within the STC,
##: All thanks and rights for the original script "map3d" go to StackOverLoader (Spacedman))

STC_Internal_Track_Visualization <-
  ##: Visualize the STC Track data
  STC_Internal_Track_Visualizer(
    Population_Averaged_Track.df,STC_Title =
      STC_Title,symbol_l.p.s = "l",add = T,Color = "red"
  )

##: (add to the STC visualization scene the STC track data for exploratorary data analysis)


STC_Internal_KDE_Visualization <- ##: Visualize the STC KDE data
  STC_Internal_KDE_Visualizer(
    STC_Animal_Movement_KDE,
    colors = c("red","green"),drawpoints = F, add = T, STC_Title = STC_Title
  )

##: (add to the STC visualization scene the STC KDE data for exploratorary data analysis)

########################################################################################
########################################################################################
########################################################################################

########################################################################################
### RGL package functions that allow for manipulation and capture of the 3d (STC) visualization scene

##: Manipulate the 3d / STC visualiztion scene

rgl.open()    #: Opens a new device
rgl.close()   #: Closes the current device
rgl.clear()   #: Clears the current device
rgl.cur()     #: Returns the active device ID
rgl.quit()    #: Shutdowns the RGL device system

rgl.snapshot (##: take a snapshot of the current scene (png or pdf)
fmt = "png",filename = "Thesis_STC_Output/Test_Plot_Single_Influence_pt2.png")

writeWebGL ( ##: write the current scene to HTML:
dir = "Thesis_STC_Output/",filename = "Test_Plot_Base_Map_Progress.html",snapshot = T)

########################################################################################
########################################################################################
########################################################################################

plotkml