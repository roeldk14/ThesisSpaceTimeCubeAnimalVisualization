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
# install.packages("PBSmapping")
# install.packages("fields")

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
library("PBSmapping")
library("fields")

##: Load Functions

source("Thesis_STC_R/160215_STC_movebank_CSV_to_dataframe.R")
source("Thesis_STC_R/160216_STC_Time_Period_Selector.R")
source("Thesis_STC_R/160222_STC_Geocentre_Midpoint_Calculator.R")
source("Thesis_STC_R/160216_STC_Individual_Averaged_Tracks.R")
source("Thesis_STC_R/160222_STC_Population_Averaged_Track.R")
source("Thesis_STC_R/160302_STC_Dataframe_List_Maker_By_Individual.R")
source("Thesis_STC_R/160216_STC_KDE_Calculator.R")
source("Thesis_STC_R/160303_STC_Reproject_LatLong_to_UTM_Functions_Script.R")
source("Thesis_STC_R/160222_STC_Geocentre&Distance&Interaction_Calculator.R")
source("Thesis_STC_R/150224_STC_Base_Map_Generator_and_Visualizer_Functions.R")
source("Thesis_STC_R/160215_STC_Internal_Visualizer_Functions.R")

##: Open CSV file and write to DF

##: (Open a chosen CSV file and write it to dataframe format (preferably from MoveBank.org))

STC_Animal_Movement.df <-
  STC_Movebank_CSVtoDF("Thesis_STC_Data/Swainson's Hawks.csv")

##: Investigate data

head(STC_Animal_Movement.df)
tail(STC_Animal_Movement.df)

unique(STC_Animal_Movement.df$Identifier)
########################################################################################
########################################################################################
########################################################################################

########################################################################################
###set global parameters

##: Time period of interest

t1 <- "1995-08-18"
t2 <- "1996-03-19"

##: Summer Period

St1 <- "1995-05-01"
St2 <- "1995-09-30"

##: Winter Period

Wt1 <- "1995-11-01"
Wt2 <- "1996-02-29"

##: Identifier

Identifier <- "SW"

##: STC_Global_Title

STC_Title <- "Swainsons Hawk"

subtitle <- "Initial Test Visualization"

boundingbox <-
  bounding.box.xy(x = STC_Animal_Movement.df$long, y = STC_Animal_Movement.df$lat)

##: Set Lat Long Projection

EPSG <- make_EPSG()

##: search for projection



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
  STC_time_period_selector(STC_Animal_Movement.df, t1, t2)

##: (subset from a given dataset the time period of interest)

head(STC_Animal_Movement_time_period_subset.df)

Individual_Averaged_Animal_Movement_Tracks.df <-
  ##: Calculate individual averaged tracks for a chosen dataset
  STC_Individual_Averaged_Tracks_Calculator(STC_Animal_Movement_time_period_subset.df, t1, t2)

##: (an average geographic coordinate is calcualted for each individual
##: on each day from all locations recorded on that day)

head(Individual_Averaged_Animal_Movement_Tracks.df)

Population_Averaged_Track.df <-
  ##: Calculate Population Averaged Track for a chosen animal dataset
  STC_Population_Averaged_Track_Calculator(Individual_Averaged_Animal_Movement_Tracks.df,
                                           t1,
                                           t2,
                                           Identifier)

##: (an average geographic coordinate is calcualted for each day from all locations recorded
##: on that day as long as n locations exceeds one, note: generally uses the individual tracks
##: function output )

tail(Population_Averaged_Track.df)


STC_Animal_Movement_Individuals.List.df <-
  ##: Make a list of indivduals dataframes
  STC_Individuals_Dataframe_List_Maker(Individual_Averaged_Animal_Movement_Tracks.df)

##: (split a dataframe into smaller dataframes containing individuals dataframes contained within a list)

STC_Animal_Movement_KDE <-
  ##: calculate KDE for a chosen animal dataset
  STC_KDE_Calculator(STC_Animal_Movement_time_period_subset.df, proj = "LL")

##: (calculate the 95% and 50% kernel density estimate or home range from a given dataset)

Population_Averaged_Track.df <-
  ##: add UTM zones and values to a lat long dataframe
  STC_UTM_Calculator(Population_Averaged_Track.df)

Individual_Averaged_Animal_Movement_Tracks.df <-
  ##: add UTM zones and values to a lat long dataframe
  STC_UTM_Calculator(Individual_Averaged_Animal_Movement_Tracks.df)

STC_Animal_Movement_time_period_subset.df <-
  ##: add UTM zones and values to a lat long dataframe
  STC_UTM_Calculator(STC_Animal_Movement_time_period_subset.df)

##: Calculate the UTM Zones and Easting and Northing for a dataframe based on their long lat values

STC_Base_Map <- ##: Generate a Basemap
  STC_Base_Map_Generator(
    STC_Animal_Movement_time_period_subset.df,
    Zoom = NULL,
    Type = "bing",
    MergeTiles = TRUE,
    Title = STC_Title,
    proj = Projection_LatLong
  )

##: (retrieve and generate a basemap using the openstreetmap function)


STC_Outliers <-
  ##:Retrieve outliers from the dataset based on the geo distance between points
  Distance_Outlier_Calculator(
    total_dataframe = STC_Animal_Movement_time_period_subset.df,
    pop_dataframe = Population_Averaged_Track.df,
    t1 = t1,
    t2 = t2,
    outlier_buffer_in_km = 1000
  )

##: (Retrieve outliers from the dataset based on the geo distance between points with the same time stamp)

STC_Interactions <-
  ##:Retrieve possible interactions between individuals from the dataset based on the geo distance between points
  Distance_Interaction_Calculator(
    total_dataframe = STC_Animal_Movement_time_period_subset.df,
    t1 = t1,
    t2 = t2,
    interaction_radius_in_km = 10
  )

##: (Retrieve possible interactions between individuals from the dataset based on the geo distance between points with the same time stamp)


########################################################################################
########################################################################################
########################################################################################

########################################################################################
### Generate internal STC visualizations for exploratory data anaylsis (initial visualization
### consists of the STC cube and basemap, any and all other additions are the users choice

rgl.close() 

mfrow3d(1, 2) ##: use only if visualizing two plots or more within the device scene

STC_2D_Background_Visualization(
  map = STC_Base_Map,
  STC_Animal_Movement_time_period_subset.df$long,
  STC_Animal_Movement_time_period_subset.df$lat
)

next3d(reuse = FALSE) ##: move on to using another scene section

##: Visualize the STC

STC_Internal_Visualization_Setup (
  dataframe = STC_Animal_Movement_time_period_subset.df,
  STC_Title = STC_Title,
  subtitle = subtitle,
  proj = "LL"
)

##: (Construct and Visualize the Space Time Cube to the specifications of the dataset
##: being explored)

##: Visualize the Base Map within the STC

STC_Base_Map_3d_Visualizer(STC_Base_Map,
                           STC_Animal_Movement.df,
                           zvalue = 9350,
                           alpha = 1)

##: (add z values to a previosly retrieved OSM base map and visualize it within the STC,
##: All thanks and rights for the original script "map3d" go to StackOverLoader (Spacedman))


##: visualize points, lines or spheres within the STC

STC_Internal_Point_Line_Sphere_Visualizer(
  Population_Averaged_Track.df,
  x = Population_Averaged_Track.df$long,
  y = Population_Averaged_Track.df$lat,
  z = Population_Averaged_Track.df$TimeDateNumeric,
  Type = "line",
  add = TRUE,
  color = "purple"
)


##: visualize points, lines or spheres within the STC (visualize interactions)

STC_Internal_Point_Line_Sphere_Visualizer(
  STC_Interactions,
  x = STC_Interactions$long,
  y = STC_Interactions$lat,
  z = STC_Interactions$TimeDateNumeric,
  Type = "sphere",
  add = TRUE,
  color = "red"
)


##: visualize points, lines or spheres within the STC (visualize outliers)

STC_Internal_Point_Line_Sphere_Visualizer(
  STC_Outliers,
  x = STC_Outliers$long,
  y = STC_Outliers$lat,
  z = STC_Outliers$TimeDateNumeric,
  Type = "cube",
  add = TRUE,
  color = "yellow"
)

##: (add to the STC visualization scene the STC track data for exploratorary data analysis)


##: Visualize the STC KDE data

STC_Internal_KDE_Visualizer(
  STC_Animal_Movement_KDE,
  colors = c("orange", "green"),
  drawpoints = T,
  add = T
)

##: (add to the STC visualization scene the STC KDE data for exploratorary data analysis)


##: Construct a legend

##: Legend Info (each value between ,, corresponds to one legend item ordered categorically)

##: symbology corresponding to numbers can be found at "http://www.statmethods.net/advgraphs/parameters.html"

symbolnames <- c(
  "xy locations",
  "xyz Locations",
  "Population Track",
  "Outliers",
  "Interactions",
  "KDE estimate 50%",
  "KDE Estimate 95%"
)

pointsymbols <- c(1, 16, NA, 15, 19, 15, 15)
pointsizes <- c(1,1,NA,2,2,2,2)
linesymbols <- c(NA, NA, 1, NA, NA, NA, NA)
colors <-
  c("red", "blue", "purple", "yellow", "red", "green", "orange")

##: Make the legend

legend3d(
  "topright",
  symbolnames,
  pch = pointsymbols,
  lty = linesymbols,
  col = colors,
  bty = "n",
  text.col = "blue",
  text.font = 3,
  cex = 1.2,
  pt.cex = pointsizes,
  title = "Legend"
)

##: add point info to the visualization

STC_add_point_info(
  dataframe_being_visualized = STC_Interactions,
  chosen_dataframe_column = STC_Interactions$Identifier
)

##: (add point info to the visualization next to the subject points)

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



STC_Point_locations <- ##: Select Points of interest
  STC_Identify3d(STC_Animal_Movement_time_period_subset.df)

##: (select points of interest from within the current visualization scene,
##: based on the function identidy3d. Requires the dataframe being visualized
##: including identifiers)

STC_Selected_Points.df <- ##: retireve previously selected points
  STC_Point_Retriever(STC_Animal_Movement_time_period_subset.df,
                      STC_Point_locations) ##: retrieve points of interest

STC_Selected_Points.df

##: (retreive selected points of interest from within   a dataset based on their location)

rgl.snapshot (##: take a snapshot of the current scene (png or pdf)
  fmt = "png", filename = "Thesis_STC_Output/Test_2D and 3D_plot_Swainson_Hawks.png")

writeWebGL (##: write the current scene to HTML:
  dir = "Thesis_STC_Output/",
  filename = "Test_Plot_Base_Map_Progress.html",
  snapshot = T)

########################################################################################
########################################################################################
########################################################################################

plotkml