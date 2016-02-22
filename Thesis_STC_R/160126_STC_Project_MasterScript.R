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
# ## Load Libraries

library("SpatialEpi")
library("ks")
library("zoom")
library("geotools")
library("rgeos")
library("rgdal")
library("sp")
library("ggplot2")
library("rgl")
library("dismo")
library("XML")
### Load Functions

source("Thesis_STC_R/160215_STC_movebank_CSV_to_dataframe.R")
source("Thesis_STC_R/160216_STC_Time_Period_Selector.R")
source("Thesis_STC_R/160222_STC_Geocentre_Midpoint_Calculator.R")
source("Thesis_STC_R/160216_STC_Individual_Averaged_Tracks.R")
source("Thesis_STC_R/160222_STC_Population_Averaged_Track.R")
source("Thesis_STC_R/160215_STC_Internal_Visualizer.R")

#Source("R/")

### Open CSV file and write to DF

STC_Animal_Movement.df <-
  STC_Movebank_CSVtoDF("Thesis_STC_Data/Swainson's Hawks.csv")

### Investigate data

head(STC_Animal_Movement.df)
typeof(STC_Animal_Movement.df$Identifier[1])

###################################################################
### Set parameters of interest

## Time preiod of interest

t1 <- "1995-01-01"
t2 <- "1995-12-31"

## Identifier

Identifier <- "SW"

## STC_Title

STC_Title <- "Swainsons Hawk Test"

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

### Visualiza the STC data internally for exploratorary data analysis

STC_Internal_Visualization <- STC_Internal_Visualizer(STC_Animal_Movement_time_period_subset.df,STC_Title = 
                                                        STC_Title,symbol_l.p.s = "s")

######The function writeWebGL() is used to write the current scene to HTML:
