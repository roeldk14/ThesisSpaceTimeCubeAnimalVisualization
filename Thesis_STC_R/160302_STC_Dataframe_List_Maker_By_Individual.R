### STC_Dataframe_List_Maker_By_Individual_Script Space_Time_Cube_Animal_Visualization
### 02\03\16

### creates a list of dataframes where each dataframe holds the data of a seperate individual

STC_Individuals_Dataframe_List_Maker <- function(dataframe) {
  
  Identifiers <- unique(dataframe$Identifier)
  
  Identifiers.list <- lapply(Identifiers, function(x) {
      assign(paste("animal_data_individual_",x,".df",sep = ""),dataframe[dataframe$Identifier == x,])
  })
  
  names(Identifiers.list) <- Identifiers
  
  return(Identifiers.list)
  
}