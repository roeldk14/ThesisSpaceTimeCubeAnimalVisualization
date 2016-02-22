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
source("Thesis_STC_R/160216_STC_Individual_Averaged_Tracks.R")
source("R/")
#Source("R/")

### Open CSV file and write to DF

STC_Animal_Movement.df <- STC_Movebank_CSVtoDF("Thesis_STC_Data/Swainson's Hawks.csv")

head(STC_Animal_Movement.df)

### Subset time period of interest

## Time preiod of interest

t1 <- "1995-01-01"
t2 <- "1995-12-31"

STC_Animal_Movement_time_period_subset.df <- STC_time_period_selector(STC_Animal_Movement.df,t1,t2)

head(STC_Animal_Movement_time_period_subset.df)

### Calculate Individual Averaged Tracks

Individual_Averaged_Animal_Movement_Tracks.df <-Individual_Averaged_Tracks_Calculator(STC_Animal_Movement_time_period_subset.df,t1,t2)

head(Individual_Averaged_Animal_Movement_Tracks.df)


######The function writeWebGL() is used to write the current scene to HTML:
