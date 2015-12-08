#include library() as necessary

shinyUI(navbarPage("Violation Dashboard",
  tabPanel("Violation Closeout"),
  #under this I can add the specific layout elements of this page for example
  #sidebarLayout(
  #    sidebarPanel(
  #      radioButtons("plotType", "Plot type",
  #        c("Scatter"="p", "Line"="l")
  #      )
  #    ),
  #    mainPanel(
  #      plotOutput("plot")
  #    )
  #  )
  #),
  #make sure to remove ), after Closeout"
  #and make ), the very last elements of this list
  tabPanel("Violation Frequency"),
  tabPanel("Violation Location")
))
