##DDM Dashboard

library(shiny)
library(openxlsx)

all.violations <- read.xlsx("violation-dashboard/Violation Report ALL.xlsx")
nrow(all.violations)
##this generates an error that the Excel does not exists

ui <- fluidPage()

server <- function(input, output) {}

shinyApp(ui = ui, server = server)
