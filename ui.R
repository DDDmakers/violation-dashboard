##UI

shinyUI(navbarPage("Violation Dashboard",
                   tabPanel("Complaint Closeout",
                            titlePanel("Analysis of Complaints Administered by the DOCE"),
                            sidebarLayout(
                              sidebarPanel(
                                selectInput(inputId="complaint",
                                            label= "Type of Complaint - Histogram",
                                            ##Had to manual enter the choices. The code choices = colnames(closedViolations)
                                            ##resulted in an error in which R could not find the object closedViolations
                                            ##even though it is created in the server.R script
                                            choices = c("BedBugs",	"BlockedExits",	"BlueBinRequest",
                                            "BuildingPermit",	"BulkHouseholdItems",	"CertofUseBar",
                                            "CertofUseFoodStore",	"CertofUseRestaurant",	"CleanUpRqstPublicProp",	
                                            "ComplaintReqstGeneral",	"ConstDemoDebris",	"CornersNeedSnowRemoval",
                                            "Demolition",	"ElectricalHazard",	"FaultyEquipment",	"FireAlarm",	"FireSafety",
                                            "GraffitiPrivateProperty",	"GraffitiPublicProperty",	"Heating",
                                            "IllegalTrashSetOut",	"Infestation",	"MedicalWasteRefused",	"NoSmokeDetectors",
                                            "Other",	"OutdoorIllegalBurning",	"OverCapacity",	"OvergrownVegPublic",	"OvergrowthPrivateOcc",
                                            "PreventativeCodeEnforce",	"ExteriorPropertyMaintenance",	"InteriorPropertyMaintenance",
                                            "RepairCreekFencing",	"SanitationSpecialReqst",	"SewerBackUp",	"SprinklerSystem",
                                            "StructuralIssues",	"SuppressionNotSprinkler",	"TenantSafetyConcerns",	"TrashDebrisPrivateOcc",
                                            "TreeInspectProblemReq",	"TreeLimbStumpRemoval",	"UnsafeConditions",	"VacantHouseOpentoEntry",
                                            "VacantLotOvergrown",	"VacantLotTrashDebris",	"VacantStructureHazard",	"VacantIllegalOccupancy",
                                            "WaterShopAllComplaints",	"YardWaste",	"ZoningViolations",	"AllComplaints")),
                                selectInput(inputId = "complaint2",
                                            label= "Type of Complaint - Table",
                                            ##See note about previous inputId
                                            choices= c("BedBugs",	"BlockedExits",	"BlueBinRequest",
                                            "BuildingPermit",	"BulkHouseholdItems",	"CertofUseBar",
                                            "CertofUseFoodStore",	"CertofUseRestaurant",	"CleanUpRqstPublicProp",	
                                            "ComplaintReqstGeneral",	"ConstDemoDebris",	"CornersNeedSnowRemoval",
                                            "Demolition",	"ElectricalHazard",	"FaultyEquipment",	"FireAlarm",	"FireSafety",
                                            "GraffitiPrivateProperty",	"GraffitiPublicProperty",	"Heating",
                                            "IllegalTrashSetOut",	"Infestation",	"MedicalWasteRefused",	"NoSmokeDetectors",
                                            "Other",	"OutdoorIllegalBurning",	"OverCapacity",	"OvergrownVegPublic",	"OvergrowthPrivateOcc",
                                            "PreventativeCodeEnforce",	"ExteriorPropertyMaintenance",	"InteriorPropertyMaintenance",
                                            "RepairCreekFencing",	"SanitationSpecialReqst",	"SewerBackUp",	"SprinklerSystem",
                                            "StructuralIssues",	"SuppressionNotSprinkler",	"TenantSafetyConcerns",	"TrashDebrisPrivateOcc",
                                            "TreeInspectProblemReq",	"TreeLimbStumpRemoval",	"UnsafeConditions",	"VacantHouseOpentoEntry",
                                            "VacantLotOvergrown",	"VacantLotTrashDebris",	"VacantStructureHazard",	"VacantIllegalOccupancy",
                                            "WaterShopAllComplaints",	"YardWaste",	"ZoningViolations",	"AllComplaints")),
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
                            mainPanel("All Properties with Open Violations", plotOutput("map1"))
                            
                            )

))
