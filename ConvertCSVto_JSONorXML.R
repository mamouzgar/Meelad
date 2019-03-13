# Meelad Amouzgar
#!/usr/bin/env Rscript
# This script converts a CSV file with headers to XML or JSON, depending on
# the command line argument supplied.
#
# This script will be executed by calling:
#
#    ```
#    Rscript src/lab1.R xml/json <filename>
#    ```
#
# Output of XML and JSON should be printed to stdout.
# setwd("C:/Users/meela/mamouzgar-lab-json-xml-r")
require(jsonlite)
require(XML)

parse_csv <- function(filename) {
  # Parse a CSV file by separating it into headers and additional data.
  # Returns an R structure containing the headers from the csv file and the data
  df <- read.csv(file=filename, header=T) #, na.strings = c("",NULL))
  return(df)
}

###################################
# Return the JSON output
jsonOutput <- function(df) { 
  result <- list() # result is an empty list
  result <- apply(df, 1, function(x) list(patient= as.list(x))) # For each row in the dataframe, each patient's info is converted into a list and the output for all patients assigned to result.
  result <- list(records = as.list(result)) # Nests the previous (patient) list as a microlist of records, and records is converted to a macrolist encompassing all patients.
  result <- toJSON(result, pretty= TRUE, auto_unbox= TRUE) # the macrolist is converted to JSON.
  return(result)
}
########
# df$mrn <- as.character(df$mrn)

###################################
# Returns the XML output
# Adds a patient node under the records node then goes through each column containing the patient's information and adds that information under the patient node.
XMLOutput <- function(df) {
  result <- newXMLNode("records")
  for (i in 1:nrow(df)) {
    patient = newXMLNode("patient", parent= result) # create a new XML node for the patient under the records node.
    for (j in 1:ncol(df)) {
      newXMLNode(colnames(df)[j], parent=patient, namespaces= toString(df[i,j]) ) # adds patient information (columns) into the respective patient's node.
    }
  }
  return(result)
}


## MAIN
main <- function(){
  args <- commandArgs(TRUE)
  filename <- args[2]
  if (args[1] == 'json'){
    json <- jsonOutput(parse_csv(filename)) } else{
      xml <- XMLOutput(parse_csv(filename))
    }
  sink("stdout", append=FALSE, split=TRUE)
  if (args[1] == 'json'){
    print(json)} else {
      print(xml)
    }
  sink()
}
main()


# 
# filename = args[2]
# json <- jsonOutput(parse_csv(filename))
# xml <- XMLOutput(parse_csv(filename))
# sink("stdout", append=FALSE, split=TRUE)
# if (args[1] == 'json'){
#   print(json)} else {
#     print(xml)
# }
# sink()
