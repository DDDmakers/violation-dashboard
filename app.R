##DDM Dashboard

library(shiny)

all.violations <- read.xlsx("violation-dashboard/Violation Report ALL.xlsx")
nrow(all.violations)


ui <- fluidPage()

server <- function(input, output) {}

shinyApp(ui = ui, server = server)
