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

# install.packages("ks")
# install.packages("rgdal")
# install.packages("sp")
# install.packages("ggplot2")
# install.packages("rgl")
# install.packages("OpenStreetMap")
# install.packages("spatstat")
# install.packages("PBSmapping")
# install.packages("fields")
# install.packages("rglwidget")
# install.packages("plotKML")
# install.packages("spacetime")
# install.packages("R2G2")


##: Load Libraries


library("ks")
library("rgdal")
library("sp")
library("ggplot2")
library("rgl")
library("OpenStreetMap")
library("spatstat")
library("PBSmapping")
library("fields")
library("rglwidget")
library("plotKML")
library("spacetime")
library("R2G2")

##: Load Functions

source("Thesis_STC_R/160215_STC_movebank_CSV_to_dataframe.R")
source("Thesis_STC_R/160216_STC_Time_Period_Selector.R")
source("Thesis_STC_R/160216_STC_Individual_Averaged_Tracks.R")
source("Thesis_STC_R/160222_STC_Population_Averaged_Track.R")
source("Thesis_STC_R/160302_STC_Dataframe&Lines_List_Maker_By_Individual.R")
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

totaltimerange <- range(STC_Animal_Movement.df$TimeDate)

paste(totaltimerange)

unique(STC_Animal_Movement.df$Identifier)
########################################################################################
########################################################################################
########################################################################################

########################################################################################
###set global parameters

##: Time period of interest

t1 <- totaltimerange[1]
t2 <- totaltimerange[2]

##: Sub Period of Interest

St1 <- "1996-05-01"
St2 <- "1997-05-01"

##: Winter Period

Wt1 <- "1995-11-01"
Wt2 <- "1996-02-29"

##: Identifier

Identifier <- "SW"

##: STC_Global_Title

STC_Title <- "Swainsons Hawk"

subtitle <- paste("Study Period", t1, ":", t2, sep = " ")

subtitle_subperiod <- paste("Study Period", St1, ":", St2, sep = " ")

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
tail(Individual_Averaged_Animal_Movement_Tracks.df)

Population_Averaged_Track.df <-
  ##: Calculate Population Averaged Track for a chosen animal dataset
  STC_Population_Averaged_Track_Calculator(Individual_Averaged_Animal_Movement_Tracks.df,
                                           t1,
                                           t2,
                                           Identifier)

##: (an average geographic coordinate is calcualted for each day from all locations recorded
##: on that day as long as n locations exceeds one, note: generally uses the individual tracks
##: function output )

head(Population_Averaged_Track.df)
tail(Population_Averaged_Track.df)


STC_Animal_Movement_Individuals.List.df <-
  ##: Make a list of indivduals dataframes
  STC_Individuals_Dataframe_List_Maker(Individual_Averaged_Animal_Movement_Tracks.df)

##: (split a dataframe into smaller dataframes containing individuals dataframes contained within a list)

STC_Animal_Movement_Individuals.Lines <- ##: Make a List of Line objects
  STC_Individuals_Lines_List_Maker(STC_Animal_Movement_Individuals.List.df)

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
###############################################################################################
###############################################################################################
##points for KDE estimates: 3593 3600 4512 1346 3121 2994 3789  432 1962 1989 2040  810  852

KDE_points <- c(3593, 3600, 4512, 1346, 3121, 2994, 3789,  432, 1962, 1989, 2040,  810,  852)
STC_Selected_Points.df <- ##: retireve previously selected points
  STC_Point_Retriever(STC_Animal_Movement_time_period_subset.df,
                      KDE_points) ##: retrieve points of interest


###############################################################################

##: home range Time period of interest 1

kdet1 <- totaltimerange[1]
kdet2 <- STC_Selected_Points.df$TimeDate[1]

STC_Animal_Movement_time_period_KDE_subset.df1 <-
  ##: Subset time period of interest
  STC_time_period_selector(STC_Animal_Movement.df, kdet1, kdet2)

STC_Animal_Movement_KDE_part_1 <-
  ##: calculate KDE for a chosen animal dataset
  STC_KDE_Calculator(STC_Animal_Movement_time_period_KDE_subset.df1, proj = "LL")

###############################################################################

##: home range Time period of interest 1

kdet3 <- STC_Selected_Points.df$TimeDate[2]
kdet4 <- STC_Selected_Points.df$TimeDate[3]

STC_Animal_Movement_time_period_KDE_subset.df2 <-
  ##: Subset time period of interest
  STC_time_period_selector(STC_Animal_Movement.df, kdet3, kdet4)



STC_Animal_Movement_KDE_part_2 <-
  ##: calculate KDE for a chosen animal dataset
  STC_KDE_Calculator(STC_Animal_Movement_time_period_KDE_subset.df2, proj = "LL")


###############################################################################

##: home range Time period of interest 1

kdet5 <- STC_Selected_Points.df$TimeDate[4]
kdet6 <- STC_Selected_Points.df$TimeDate[5]

STC_Animal_Movement_time_period_KDE_subset.df3 <-
  ##: Subset time period of interest
  STC_time_period_selector(STC_Animal_Movement.df, kdet5, kdet6)

STC_Animal_Movement_KDE_part_3 <-
  ##: calculate KDE for a chosen animal dataset
  STC_KDE_Calculator(STC_Animal_Movement_time_period_KDE_subset.df3, proj = "LL")


###############################################################################

##: home range Time period of interest 1

kdet7 <- STC_Selected_Points.df$TimeDate[6]
kdet8 <- STC_Selected_Points.df$TimeDate[7]

STC_Animal_Movement_time_period_KDE_subset.df4 <-
  ##: Subset time period of interest
  STC_time_period_selector(STC_Animal_Movement.df, kdet7, kdet8)

STC_Animal_Movement_KDE_part_4 <-
  ##: calculate KDE for a chosen animal dataset
  STC_KDE_Calculator(STC_Animal_Movement_time_period_KDE_subset.df4, proj = "LL")


###############################################################################

##: home range Time period of interest 1

kdet9 <- STC_Selected_Points.df$TimeDate[8]
kdet10 <- STC_Selected_Points.df$TimeDate[9]

STC_Animal_Movement_time_period_KDE_subset.df5 <-
  ##: Subset time period of interest
  STC_time_period_selector(STC_Animal_Movement.df, kdet9, kdet10)

STC_Animal_Movement_KDE_part_5 <-
  ##: calculate KDE for a chosen animal dataset
  STC_KDE_Calculator(STC_Animal_Movement_time_period_KDE_subset.df5, proj = "LL")


###############################################################################

##: home range Time period of interest 1

kdet11 <- STC_Selected_Points.df$TimeDate[10]
kdet12 <- STC_Selected_Points.df$TimeDate[11]

STC_Animal_Movement_time_period_KDE_subset.df6 <-
  ##: Subset time period of interest
  STC_time_period_selector(STC_Animal_Movement.df, kdet11, kdet12)

STC_Animal_Movement_KDE_part_6 <-
  ##: calculate KDE for a chosen animal dataset
  STC_KDE_Calculator(STC_Animal_Movement_time_period_KDE_subset.df6, proj = "LL")

###############################################################################

##: home range Time period of interest 1

kdet13 <- STC_Selected_Points.df$TimeDate[12]
kdet14 <- STC_Selected_Points.df$TimeDate[13]

STC_Animal_Movement_time_period_KDE_subset.df7 <-
  ##: Subset time period of interest
  STC_time_period_selector(STC_Animal_Movement.df, kdet13, kdet14)

STC_Animal_Movement_KDE_part_7 <-
  ##: calculate KDE for a chosen animal dataset
  STC_KDE_Calculator(STC_Animal_Movement_time_period_KDE_subset.df7, proj = "LL")

################################################################################
########################################################################################
########################################################################################
########################################################################################

########################################################################################
### Generate internal STC visualizations for exploratory data anaylsis (initial visualization
### consists of the STC cube and basemap, any and all other additions are the users choice

rgl.close()

mfrow3d(1, 1) ##: use only if visualizing two plots or more within the device scene

STC_2D_Background_Visualization(
  map = STC_Base_Map,
  points =
    STC_Animal_Movement_time_period_subset.df,
  outliers = STC_Outliers,
  interactions = STC_Interactions,
  colP = "red",
  colO = "yellow",
  colI = "blue",
  title = STC_Title,
  subtitle = subtitle,
  coltext = "white"
)

next3d(reuse = FALSE) ##: move on to using another scene section

##: Visualize the STC

STC_Internal_Visualization_Setup (
  dataframe = STC_Animal_Movement_time_period_subset.df,
  STC_Title = NULL,
  subtitle = NULL,
  proj = "LL"
)

##: (Construct and Visualize the Space Time Cube to the specifications of the dataset
##: being explored)

##: Visualize the Base Map within the STC

STC_Base_Map_3d_Visualizer(STC_Base_Map,
                           STC_Animal_Movement.df,
                           zvalue = 0,
                           alpha = 1)

##: (add z values to a previosly retrieved OSM base map and visualize it within the STC,
##: All thanks and rights for the original script "map3d" go to StackOverLoader (Spacedman))


##: visualize points, lines or spheres within the STC

STC_Internal_Point_Line_Sphere_Visualizer(
  Population_Averaged_Track.df,
  x = Population_Averaged_Track.df$long,
  y = Population_Averaged_Track.df$lat,
  z = Population_Averaged_Track.df$Days_Count,
  Type = "line",
  add = TRUE,
  color = "purple"
)


##: visualize points, lines or spheres within the STC (visualize interactions)

STC_Internal_Point_Line_Sphere_Visualizer(
  STC_Interactions,
  x = STC_Interactions$long,
  y = STC_Interactions$lat,
  z = STC_Interactions$Days_Count,
  Type = "sphere",
  add = TRUE,
  color = "blue"
)


##: visualize points, lines or spheres within the STC (visualize outliers)

STC_Internal_Point_Line_Sphere_Visualizer(
  STC_Outliers,
  x = STC_Outliers$long,
  y = STC_Outliers$lat,
  z = STC_Outliers$Days_Count,
  Type = "cube",
  add = TRUE,
  color = "yellow"
)

##: (add to the STC visualization scene the STC track data for exploratorary data analysis)


##: Visualize the STC KDE data

STC_Internal_KDE_Visualizer(
  STC_Animal_Movement_KDE_part_1,
  colors = c("orange", "green"),
  drawpoints = F,
  add = T
)

STC_Internal_KDE_Visualizer(
  STC_Animal_Movement_KDE_part_2,
  colors = c("orange", "green"),
  drawpoints = F,
  add = T
)
STC_Internal_KDE_Visualizer(
  STC_Animal_Movement_KDE_part_3,
  colors = c("orange", "green"),
  drawpoints = F,
  add = T
)
STC_Internal_KDE_Visualizer(
  STC_Animal_Movement_KDE_part_4,
  colors = c("orange", "green"),
  drawpoints = F,
  add = T
)
STC_Internal_KDE_Visualizer(
  STC_Animal_Movement_KDE_part_5,
  colors = c("orange", "green"),
  drawpoints = F,
  add = T
)
STC_Internal_KDE_Visualizer(
  STC_Animal_Movement_KDE_part_6,
  colors = c("orange", "green"),
  drawpoints = F,
  add = T
)

STC_Internal_KDE_Visualizer(
  STC_Animal_Movement_KDE_part_7,
  colors = c("orange", "green"),
  drawpoints = F,
  add = T
)
##: (add to the STC visualization scene the STC KDE data for exploratorary data analysis)


##: Construct a legend

##: Legend Info (each value between ,, corresponds to one legend item ordered categorically)

##: symbology corresponding to numbers can be found at "http://www.statmethods.net/advgraphs/parameters.html"

symbolnames <- c(
  "population track (spatial)",
  "outliers (spatial)",
  "interactions (spatial)",
  "Locations (space-time)",
  "Outliers (space-time)",
  "Interactions (space-time)",
  "Population Track (space-time)",
  "KDE estimate 50% (Home Range)",
  "KDE Estimate 95% (Home Range)"
)

pointsymbols <- c(NA, 4, 8, 16, 15, 19, NA, 15, 15)
pointsizes <- c(NA, 1, 1, 1, 2, 2, NA, 2, 2)
linesymbols <- c(1, NA, NA, NA, NA, NA, 1, NA, NA)
colors <-
  c("purple",
    "Yellow",
    "blue",
    "Blue",
    "yellow",
    "blue",
    "purple",
    "green",
    "orange")

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

STC_Date_Info_Points <-
  ##: retrieve a sequence of points from within the dataframe so as to provide date info to a scene via text3d (STC_add_point_info)
  Sequence_Date_points(dataframe = STC_Animal_Movement_time_period_subset.df, time_interval = 100)

##: add point info to the visualization

STC_add_point_info(
  dataframe_being_visualized = STC_Date_Info_Points,
  chosen_dataframe_column = STC_Date_Info_Points$TimeDate
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
  fmt = "png", filename = "Thesis_STC_Output/Final_Productminus2D.png")

writeWebGL (
  ##: write the current scene to HTML:
  dir = "webGL",
  filename = file.path(dir, "Full_Time_Frame_Swainson_Hawks.html"),
  template = system.file(file.path("WebGL", "template.html"), package = "rgl"),
  ,
  snapshot = T
)

##: Spin the visualized scene

play3d(spin3d(axis = c(0, 0, 1)), duration = 30)


##: make a GIF movie of the visualized scene (requires imagemagick)

movie3d(
  f = spin3d(axis = c(0, 0, 1)),
  duration = 15,
  fps = 15,
  movie = "Swainson_Hawks_Finalv3",
  frames = "Swainson_Hawks_Finalv3",
  dir = "Thesis_STC_Output",
  convert = TRUE,
  clean = TRUE,
  type = "gif",
  startTime = 0,
)

########################################################################################
########################################################################################
########################################################################################

########################################################################################
###: What follows are Visualizations of exemplars for a thesis report
########################################################################################


### Examples 1 all three units of interest

rgl.close()

mfrow3d(1, 1) ##: use only if visualizing two plots or more within the device scene

##: Visualize the STC

STC_Internal_Visualization_Setup (
  dataframe = STC_Animal_Movement_Individuals.List.df$SW17,
  STC_Title = STC_Title,
  subtitle = subtitle_subperiod,
  proj = "LL"
)

##: (Construct and Visualize the Space Time Cube to the specifications of the dataset
##: being explored)

##: Visualize the Base Map within the STC

STC_Base_Map_3d_Visualizer(STC_Base_Map,
                           STC_Animal_Movement.df,
                           zvalue = 350,
                           alpha = 1)

##: (add z values to a previosly retrieved OSM base map and visualize it within the STC,
##: All thanks and rights for the original script "map3d" go to StackOverLoader (Spacedman))


##: visualize points, lines or spheres within the STC

STC_Internal_Point_Line_Sphere_Visualizer(
  STC_Animal_Movement_Individuals.List.df$SW23,
  x = STC_Animal_Movement_Individuals.List.df$SW23$long,
  y = STC_Animal_Movement_Individuals.List.df$SW23lat,
  z = STC_Animal_Movement_Individuals.List.df$SW23$Days_Count,
  Type = "line",
  add = TRUE,
  color = "black"
)

STC_Internal_Point_Line_Sphere_Visualizer(
  STC_Animal_Movement_Individuals.List.df$SW25,
  x = STC_Animal_Movement_Individuals.List.df$SW25$long,
  y = STC_Animal_Movement_Individuals.List.df$SW25$lat,
  z = STC_Animal_Movement_Individuals.List.df$SW25$Days_Count,
  Type = "line",
  add = TRUE,
  color = "blue"
)

STC_Internal_Point_Line_Sphere_Visualizer(
  STC_Animal_Movement_Individuals.List.df$SW16,
  x = STC_Animal_Movement_Individuals.List.df$SW16$long,
  y = STC_Animal_Movement_Individuals.List.df$SW16$lat,
  z = STC_Animal_Movement_Individuals.List.df$SW16$Days_Count,
  Type = "line",
  add = TRUE,
  color = "red"
)

STC_Internal_Point_Line_Sphere_Visualizer(
  STC_Animal_Movement_Individuals.List.df$SW17,
  x = STC_Animal_Movement_Individuals.List.df$SW17$long,
  y = STC_Animal_Movement_Individuals.List.df$SW17$lat,
  z = STC_Animal_Movement_Individuals.List.df$SW17$Days_Count,
  Type = "line",
  add = TRUE,
  color = "orange"
)

STC_Internal_Point_Line_Sphere_Visualizer(
  STC_Animal_Movement_Individuals.List.df$SW27,
  x = STC_Animal_Movement_Individuals.List.df$SW27$long,
  y = STC_Animal_Movement_Individuals.List.df$SW27$lat,
  z = STC_Animal_Movement_Individuals.List.df$SW27$Days_Count,
  Type = "line",
  add = TRUE,
  color = "green"
)

STC_Internal_Point_Line_Sphere_Visualizer(
  STC_Animal_Movement_Individuals.List.df$SW31,
  x = STC_Animal_Movement_Individuals.List.df$SW31$long,
  y = STC_Animal_Movement_Individuals.List.df$SW31$lat,
  z = STC_Animal_Movement_Individuals.List.df$SW31$Days_Count,
  Type = "line",
  add = TRUE,
  color = "yellow"
)

STC_Internal_Point_Line_Sphere_Visualizer(
  STC_Animal_Movement_Individuals.List.df$SW41,
  x = STC_Animal_Movement_Individuals.List.df$SW41$long,
  y = STC_Animal_Movement_Individuals.List.df$SW41$lat,
  z = STC_Animal_Movement_Individuals.List.df$SW41$Days_Count,
  Type = "line",
  add = TRUE,
  color = "pink"
)
##: visualize points, lines or spheres within the STC (visualize interactions)

STC_Interactions_subset <-
  ##: Subset time period of interest
  STC_time_period_selector(STC_Interactions, St1, St2)

STC_Internal_Point_Line_Sphere_Visualizer(
  STC_Interactions_subset,
  x = STC_Interactions_subset$long,
  y = STC_Interactions_subset$lat,
  z = STC_Interactions_subset$Days_Count,
  Type = "sphere",
  add = TRUE,
  color = "blue"
)

symbolnames <- c(
  "SW23 Track",
  "SW25 Track",
  "SW16 Track",
  "SW17 Track",
  "SW27 Track",
  "SW31 Track",
  "SW41 Track",
  "Interactions"
)

pointsymbols <- c(NA,NA,NA,NA,NA,NA,NA, 19)
pointsizes <- c(NA,NA,NA,NA,NA,NA,NA,2)
linesymbols <- c(1, 1, 1, 1, 1, 1, 1, NA)
colors <-
  c("black",
    "blue",
    "red",
    "Orange",
    "green",
    "yellow",
    "pink",
    "blue")

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
  title = "Individual Tracks with Interactions"
)

########################################################################################
########################################################################################

next3d(reuse = FALSE) ##: move on to using another scene section

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
                           zvalue = 0,
                           alpha = 1)

##: (add z values to a previosly retrieved OSM base map and visualize it within the STC,
##: All thanks and rights for the original script "map3d" go to StackOverLoader (Spacedman))


##: visualize points, lines or spheres within the STC

STC_Internal_Point_Line_Sphere_Visualizer(
  Population_Averaged_Track.df,
  x = Population_Averaged_Track.df$long,
  y = Population_Averaged_Track.df$lat,
  z = Population_Averaged_Track.df$Days_Count,
  Type = "line",
  add = TRUE,
  color = "purple"
)


##: visualize points, lines or spheres within the STC (visualize interactions)

STC_Internal_Point_Line_Sphere_Visualizer(
  STC_Interactions,
  x = STC_Interactions$long,
  y = STC_Interactions$lat,
  z = STC_Interactions$Days_Count,
  Type = "sphere",
  add = TRUE,
  color = "blue"
)


##: visualize points, lines or spheres within the STC (visualize outliers)

STC_Internal_Point_Line_Sphere_Visualizer(
  STC_Outliers,
  x = STC_Outliers$long,
  y = STC_Outliers$lat,
  z = STC_Outliers$Days_Count,
  Type = "cube",
  add = TRUE,
  color = "yellow"
)

##: (add to the STC visualization scene the STC track data for exploratorary data analysis)

STC_add_point_info(
  dataframe_being_visualized = STC_Date_Info_Points,
  chosen_dataframe_column = STC_Date_Info_Points$TimeDate
)

symbolnames <- c(
  "Outliers (space-time)",
  "Interactions (space-time)",
  "Population Track"
)

pointsymbols <- c(15, 19, NA)
pointsizes <- c(2, 2, NA)
linesymbols <- c(NA, NA, 1)
colors <-
  c(
    "yellow",
    "blue",
    "purple")

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
  title = "Population Track with Outliers and Interactions"
)

########################################################################################
########################################################################################

next3d(reuse = FALSE) ##: move on to using another scene section

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
                           zvalue = 0,
                           alpha = 1)

##: (add z values to a previosly retrieved OSM base map and visualize it within the STC,
##: All thanks and rights for the original script "map3d" go to StackOverLoader (Spacedman))


##: visualize points, lines or spheres within the STC

STC_Internal_Point_Line_Sphere_Visualizer(
  Population_Averaged_Track.df,
  x = Population_Averaged_Track.df$long,
  y = Population_Averaged_Track.df$lat,
  z = Population_Averaged_Track.df$Days_Count,
  Type = "line",
  add = TRUE,
  color = "purple"
)

##: visualize points, lines or spheres within the STC (visualize interactions)
##: Visualize the STC KDE data

STC_Internal_KDE_Visualizer(
  STC_Animal_Movement_KDE_part_1,
  colors = c("orange", "green"),
  drawpoints = F,
  add = T
)

STC_Internal_KDE_Visualizer(
  STC_Animal_Movement_KDE_part_2,
  colors = c("orange", "green"),
  drawpoints = F,
  add = T
)
STC_Internal_KDE_Visualizer(
  STC_Animal_Movement_KDE_part_3,
  colors = c("orange", "green"),
  drawpoints = F,
  add = T
)
STC_Internal_KDE_Visualizer(
  STC_Animal_Movement_KDE_part_4,
  colors = c("orange", "green"),
  drawpoints = F,
  add = T
)
STC_Internal_KDE_Visualizer(
  STC_Animal_Movement_KDE_part_5,
  colors = c("orange", "green"),
  drawpoints = F,
  add = T
)
STC_Internal_KDE_Visualizer(
  STC_Animal_Movement_KDE_part_6,
  colors = c("orange", "green"),
  drawpoints = F,
  add = T
)

STC_Internal_KDE_Visualizer(
  STC_Animal_Movement_KDE_part_7,
  colors = c("orange", "green"),
  drawpoints = F,
  add = T
)

symbolnames <- c(
  "Population Track",
  "KDE estimate 50% (Home Range)",
  "KDE Estimate 95% (Home Range)"
)

pointsymbols <- c(NA, 15, 15)
pointsizes <- c(NA, 2, 2)
linesymbols <- c(1, NA, NA)
colors <-
  c(
    "purple",
    "green",
    "orange")

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
  title = "Population Home ranges with the Population Track"
)

###############################################################################################
###############################################################################################
##points for KDE estimates: 3593 3600 4512 1346 3121 2994 3789  432 1962 1989 2040  810  852

KDE_points <- c(3593, 3600, 4512, 1346, 3121, 2994, 3789,  432, 1962, 1989, 2040,  810,  852)
STC_Selected_Points.df <- ##: retireve previously selected points
  STC_Point_Retriever(STC_Animal_Movement_time_period_subset.df,
                      KDE_points) ##: retrieve points of interest


###############################################################################

##: home range Time period of interest 1

kdet1 <- totaltimerange[1]
kdet2 <- STC_Selected_Points.df$TimeDate[1]

STC_Animal_Movement_time_period_KDE_subset.df1 <-
  ##: Subset time period of interest
  STC_time_period_selector(STC_Animal_Movement.df, kdet1, kdet2)

STC_Animal_Movement_KDE_part_1 <-
  ##: calculate KDE for a chosen animal dataset
  STC_KDE_Calculator(STC_Animal_Movement_time_period_KDE_subset.df1, proj = "LL")

###############################################################################

##: home range Time period of interest 1

kdet3 <- STC_Selected_Points.df$TimeDate[2]
kdet4 <- STC_Selected_Points.df$TimeDate[3]

STC_Animal_Movement_time_period_KDE_subset.df2 <-
  ##: Subset time period of interest
  STC_time_period_selector(STC_Animal_Movement.df, kdet3, kdet4)



STC_Animal_Movement_KDE_part_2 <-
  ##: calculate KDE for a chosen animal dataset
  STC_KDE_Calculator(STC_Animal_Movement_time_period_KDE_subset.df2, proj = "LL")


###############################################################################

##: home range Time period of interest 1

kdet5 <- STC_Selected_Points.df$TimeDate[4]
kdet6 <- STC_Selected_Points.df$TimeDate[5]

STC_Animal_Movement_time_period_KDE_subset.df3 <-
  ##: Subset time period of interest
  STC_time_period_selector(STC_Animal_Movement.df, kdet5, kdet6)

STC_Animal_Movement_KDE_part_3 <-
  ##: calculate KDE for a chosen animal dataset
  STC_KDE_Calculator(STC_Animal_Movement_time_period_KDE_subset.df3, proj = "LL")


###############################################################################

##: home range Time period of interest 1

kdet7 <- STC_Selected_Points.df$TimeDate[6]
kdet8 <- STC_Selected_Points.df$TimeDate[7]

STC_Animal_Movement_time_period_KDE_subset.df4 <-
  ##: Subset time period of interest
  STC_time_period_selector(STC_Animal_Movement.df, kdet7, kdet8)

STC_Animal_Movement_KDE_part_4 <-
  ##: calculate KDE for a chosen animal dataset
  STC_KDE_Calculator(STC_Animal_Movement_time_period_KDE_subset.df4, proj = "LL")


###############################################################################

##: home range Time period of interest 1

kdet9 <- STC_Selected_Points.df$TimeDate[8]
kdet10 <- STC_Selected_Points.df$TimeDate[9]

STC_Animal_Movement_time_period_KDE_subset.df5 <-
  ##: Subset time period of interest
  STC_time_period_selector(STC_Animal_Movement.df, kdet9, kdet10)

STC_Animal_Movement_KDE_part_5 <-
  ##: calculate KDE for a chosen animal dataset
  STC_KDE_Calculator(STC_Animal_Movement_time_period_KDE_subset.df5, proj = "LL")


###############################################################################

##: home range Time period of interest 1

kdet11 <- STC_Selected_Points.df$TimeDate[10]
kdet12 <- STC_Selected_Points.df$TimeDate[11]

STC_Animal_Movement_time_period_KDE_subset.df6 <-
  ##: Subset time period of interest
  STC_time_period_selector(STC_Animal_Movement.df, kdet11, kdet12)

STC_Animal_Movement_KDE_part_6 <-
  ##: calculate KDE for a chosen animal dataset
  STC_KDE_Calculator(STC_Animal_Movement_time_period_KDE_subset.df6, proj = "LL")

###############################################################################

##: home range Time period of interest 1

kdet13 <- STC_Selected_Points.df$TimeDate[12]
kdet14 <- STC_Selected_Points.df$TimeDate[13]

STC_Animal_Movement_time_period_KDE_subset.df7 <-
  ##: Subset time period of interest
  STC_time_period_selector(STC_Animal_Movement.df, kdet13, kdet14)

STC_Animal_Movement_KDE_part_7 <-
  ##: calculate KDE for a chosen animal dataset
  STC_KDE_Calculator(STC_Animal_Movement_time_period_KDE_subset.df7, proj = "LL")

################################################################################

## Build test case for individuals with interactions 2d

STC_2D_Background_Visualization(
  map = STC_Base_Map,
  points =
    STC_Animal_Movement_time_period_subset.df,
  outliers = STC_Outliers,
  interactions = STC_Interactions,
  colP = "red",
  colO = "yellow",
  colI = "blue",
  title = STC_Title,
  subtitle = subtitle,
  coltext = "white"
)

  SW$23 color = "black"

  SW$25 color = "blue"

  SW$16 color = "red"

  SW$17 color = "orange"

  SW$27 color = "green"

  SW31$ color = "yellow"
  
 SW$41 color = "pink"

STC_Interactions_subset <-
  ##: Subset time period of interest
  STC_time_period_selector(STC_Interactions, St1, St2)

plot(STC_Base_Map, raster = TRUE)

lines(STC_Animal_Movement_Individuals.List.df$SW41$long, STC_Animal_Movement_Individuals.List.df$SW41$lat, col = "pink")
lines(STC_Animal_Movement_Individuals.List.df$SW23$long, STC_Animal_Movement_Individuals.List.df$SW23$lat, col = "black")
lines(STC_Animal_Movement_Individuals.List.df$SW25$long, STC_Animal_Movement_Individuals.List.df$SW25$lat, col = "purple")
lines(STC_Animal_Movement_Individuals.List.df$SW16$long, STC_Animal_Movement_Individuals.List.df$SW16$lat, col = "red")
lines(STC_Animal_Movement_Individuals.List.df$SW17$long, STC_Animal_Movement_Individuals.List.df$SW17$lat, col = "orange")
lines(STC_Animal_Movement_Individuals.List.df$SW27$long, STC_Animal_Movement_Individuals.List.df$SW27$lat, col = "green")
lines(STC_Animal_Movement_Individuals.List.df$SW31$long, STC_Animal_Movement_Individuals.List.df$SW31$lat, col = "yellow")
lines(STC_Animal_Movement_Individuals.List.df$SW41$long, STC_Animal_Movement_Individuals.List.df$SW41$lat, col = "pink")
plot(Animal_Movement_KDE_part_1)

points(STC_Interactions_subset$long,STC_Interactions_subset$lat, col = "blue", pch = 8)

title(main = "Seven Individual Swainson's Hawks with Interactions", line = +3, col.main = "red", cex.main = 0.8)
mtext(side = 1, "period: 1996/05/01 - 1997/05/01", line = 1, col = "red", cex = 0.8)


Animal_Movement_KDE_part_1 <- kde(x = matrix(data = c(STC_Animal_Movement_time_period_KDE_subset.df1$long,STC_Animal_Movement_time_period_KDE_subset.df1$lat),ncol = 2))
Animal_Movement_KDE_part_2 <- kde(x = matrix(data = c(STC_Animal_Movement_time_period_KDE_subset.df2$long,STC_Animal_Movement_time_period_KDE_subset.df2$lat),ncol = 2))
Animal_Movement_KDE_part_3 <- kde(x = matrix(data = c(STC_Animal_Movement_time_period_KDE_subset.df3$long,STC_Animal_Movement_time_period_KDE_subset.df3$lat),ncol = 2))
Animal_Movement_KDE_part_4 <- kde(x = matrix(data = c(STC_Animal_Movement_time_period_KDE_subset.df4$long,STC_Animal_Movement_time_period_KDE_subset.df4$lat),ncol = 2))
Animal_Movement_KDE_part_5 <- kde(x = matrix(data = c(STC_Animal_Movement_time_period_KDE_subset.df5$long,STC_Animal_Movement_time_period_KDE_subset.df5$lat),ncol = 2))
Animal_Movement_KDE_part_6 <- kde(x = matrix(data = c(STC_Animal_Movement_time_period_KDE_subset.df6$long,STC_Animal_Movement_time_period_KDE_subset.df6$lat),ncol = 2))
Animal_Movement_KDE_part_7 <- kde(x = matrix(data = c(STC_Animal_Movement_time_period_KDE_subset.df7$long,STC_Animal_Movement_time_period_KDE_subset.df7$lat),ncol = 2))

plot(Animal_Movement_KDE_part_1, col = "green",add = TRUE)
plot(Animal_Movement_KDE_part_2, col = "green",add = TRUE)
plot(Animal_Movement_KDE_part_3, col = "green",add = TRUE)
plot(Animal_Movement_KDE_part_4, col = "green",add = TRUE)
plot(Animal_Movement_KDE_part_5, col = "green",add = TRUE)
plot(Animal_Movement_KDE_part_6, col = "green",add = TRUE)
plot(Animal_Movement_KDE_part_7, col = "green",add = TRUE)



STC_2D_Background_Visualization(
  map = STC_Base_Map,
  points =
    STC_Animal_Movement_time_period_subset.df,
  outliers = STC_Outliers,
  interactions = STC_Interactions,
  colP = "red",
  colO = "yellow",
  colI = "blue",
  title = STC_Title,
  subtitle = subtitle,
  coltext = "white"
)

