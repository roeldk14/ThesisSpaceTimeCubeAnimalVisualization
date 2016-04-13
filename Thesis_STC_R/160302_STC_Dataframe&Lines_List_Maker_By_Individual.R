### STC_Dataframe&Lines_List_Maker_By_Individual_Script Space_Time_Cube_Animal_Visualization
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

########################################################################################
########################################################################################

STC_Individuals_Lines_List_Maker <- function(dataframe_Individuals_List) {
  
  Lineslist <- list()
  ID <- names(dataframe_Individuals_List)
  
  for (i in 1:length(dataframe_Individuals_List)) {
    uniquename <- names(dataframe_Individuals_List[i])
    currentdf <- as.data.frame(dataframe_Individuals_List[i])
    currentline <- Line(coords =  currentdf[,c(1,2)])
    currentlines <- Lines(slinelist = list(currentline),ID = uniquename)
    Lineslist <- append(Lineslist,currentlines)
  }
  return(Lineslist)
} 