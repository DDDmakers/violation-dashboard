##DDM Dashboard

library(shiny)
library(RCurl)

url <- "https://github.com/DDDmakers/violation-dashboard/blob/master/Violation%20Report%20ALL.csv"
url2 <- "https://github.com/DDDmakers/violation-dashboard/blob/master/all%20data%20by%20property.csv"
dat.temp <- getURL( url, ssl.verifypeer = FALSE )
dat.temp2 <- getURL( url2, ssl.verifypeer = FALSE )
all.violations <- read.csv( textConnection( dat.temp ), stringsAsFactors=FALSE )  
all.properties <- read.csv( textConnection( dat.temp2 ), stringsAsFactors=FALSE )  

rm( url )
rm( url2 )
rm( dat.temp )
rm( dat.temp2 )


ui <- fluidPage(
  headerPanel('Violation Dashboard Test'),
  sidebarPanel(
    selectInput('xcol', 'X Variable', names(all.properties)),
    selectInput('ycol', 'Y Variable', names(all.properties))
  ),
  mainPanel(
    plotOutput('plot1')
  )
)

server <- function(input, output) {

  selectedData <- reactive({
    all.properties[, c(input$xcol, input$ycol)]
  })

  output$plot1 <- renderPlot({
    par(mar = c(5.1, 4.1, 0, 1))
    plot(selectedData(),
         col = "lightblue",
         pch = 19, xlim=c(0,2050), ylim = c(0,2050))
  })

}
##this plot code does not allow for me to remove NAs, the drop downs dont work properly,
##and the xlim/ylim is limiting to the types and size of columsn that might be chosen.

shinyApp(ui = ui, server = server)
