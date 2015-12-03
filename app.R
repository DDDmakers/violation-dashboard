##DDM Dashboard

library(shiny)
library(openxlsx)

url <- "https://github.com/DDDmakers/violation-dashboard/blob/master/Violation%20Report%20ALL.xlsx"
dat.temp <- getURL( url, ssl.verifypeer = FALSE )
all.violations <- read.xlsx( textConnection( dat.temp ))  
nrow(all.violations)

##this generates an error that the Excel does not exists
#all.violations <- read.xlsx("violation-dashboard/Violation Report ALL.xlsx")

ui <- fluidPage()

server <- function(input, output) {}

shinyApp(ui = ui, server = server)
