### STC_Time_Period_Subsetter_Script Space_Time_Cube_Animal_Visualization 
### 16/02/16

### Selects Period of interest to the user for later visualization or manipulation

## Select specific period of interest

STC_Period_Selector <- function(Dataset,T1,T2) {}

t1 <- as.Date("1995-01-01")
t2 <- as.Date("1995-12-31")

## subset data

Swainsons_STC_Data_1995.df <- Swainsons_STC_Data.df[Swainsons_STC_Data.df$TimeDate %in% t1:t2]

head(Swainsons_STC_Data_1995.df)

