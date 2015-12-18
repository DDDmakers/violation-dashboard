##UI

shinyUI(navbarPage("Violation Dashboard",
                   tabPanel("Complaint Closeout",
                            titlePanel("Analysis of Complaints Administered by the DOCE"),
                            sidebarLayout(
                              sidebarPanel(
                                selectInput(inputId="complaint",
                                            label= "Type of Complaint - Histogram",
                                            choices = c("BedBugs", "BlockedExits")),
                                selectInput(inputId = "complaint2",
                                            label= "Type of Complaint - Table",
                                            choices= c("BedBugs", "BlockedExits")),
                                hr(),
                                helpText("Data from City of Syracuse, Division of Code Enforcement")),
                           
                              mainPanel(
                                tabsetPanel(type = "tabs",
                                            tabPanel("Histogram", 
                                                     plotOutput("complaintPlot"), 
                                                     h5("Summary: # of days taken to close specified complaint "), 
                                                     verbatimTextOutput("stats"), 
                                                     h5("Summary: # of days taken to close the average complaint"),     
                                                     verbatimTextOutput("stats2")),
                                            tabPanel("Table",
                                                     plotOutput("averagesPlot")))))),
                   tabPanel("Violation Frequency",
                            titlePanel("Open Violation Frequency"),
                            sidebarLayout(
                              sidebarPanel(
                                
                                selectInput(inputId = "violation", 
                                            label="Choose a violation type", 
                                            choices = c("Complaint Reqst - General", "Illegal Trash Set Out", "Property Maintenance-Ext", "Property Maintenance-Int","Trash/Debris-Private, Occ")
                                ),
                                hr(),
                                helpText("Data from City of Syracuse, Division of Code Enforcement")),
                              
                              
                              mainPanel(
                                tabsetPanel(type = "tabs",
                                            tabPanel("Graph", 
                                                     plotOutput("complaintFreq")  ))))
                   ),
                            
                   
                   tabPanel("Violation Location",
                            titlePanel("Open Violation Locations"),
                            mainPanel(
                              tabsetPanel(
                                tabPanel("All", plotOutput("map1")), 
                                tabPanel("Vacancy Status", plotOutput("map2")), 
                                tabPanel("Land Use", plotOutput("map3"))

                            
                            )
                          )
                        )
                   
                   
))
