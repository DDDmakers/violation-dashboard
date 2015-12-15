##Server App

#load libraries
library(shiny)
library(ggmap)

#Functions before Server Begins: Tab 1 Complaint Closeout
closedViolations <- read.csv("Data/ComplaintsDays.csv", stringsAsFactors = F )
averageDays <- read.csv("Data/AverageDays.csv", stringsAsFactors = F)
averageDays2 <- read.csv("Data/AverageDays2.csv", stringsAsFactors = F)

#Functions before Server Begins: Tab 2 Violation Frequency
dat <- read.csv( "Data/Violation-Report.csv", stringsAsFactors=F )
violation.date <- as.Date( dat$Violation.Date, "%m/%d/%Y" )
gt.2012 <- violation.date > "2011-12-31"
dat <- dat[ gt.2012 , ]
violation.date <- as.Date( dat$Violation.Date, "%m/%d/%Y" )
closed.date <- as.Date( dat$Complaint.Close.Date, "%m/%d/%Y" )
duration <- closed.date - violation.date 
month.year <- cut( violation.date, breaks="month" )
month.year.name <- format( violation.date, "%b-%Y" )
total.complaints <- tapply( dat$Complaint.Type, month.year, length )
total.complaints[ is.na(total.complaints) ] <- 0
dat$month.year <- month.year

#Functions before Server Begins: Tab 2 Violation Locations
open.violations <- read.csv("Data/AverageDays.csv")
syracuse <- get_map(location="Syracuse NY", zoom = 13, color="bw")
syr.map <- ggmap(syracuse, extent = "device")
vacancy <- as.factor(open.violations$VacantBuilding)
landtype <- as.factor(open.violations$LandUse)

#Begin Server
shinyServer(function(input, output, sessions) {

  #Plots for Tab 1: Complaint Closeout
  #Histogram
  output$complaintPlot <- renderPlot({
    hist(closedViolations[,input$complaint],
         na.rm = F,
         breaks = 10,
         prob = TRUE,
         main = c("# of Days Taken to Close a ", input$complaint, "Complaint"),
         xlab = "# of Days",
         border= NULL,
         col= "darkolivegreen4",
         xlim=c(0,1000),
         xaxt = "n")
    
    axis(1, 
         at=seq(from=0, to=1000, by=50), 
         pos=0)
  })
  #Statistics Table Below Histogram, by complaint
  output$stats <- renderPrint({
    summary(closedViolations[,input$complaint])
  })
  #Statistics Table Below Histogram, all complaints
  output$stats2 <- renderPrint({
    summary(closedViolations$AllComplaints)
  })
  #Plot 2, all complaints average time to closeout
  output$averagesPlot <- renderPlot({
    plot(averageDays2$Average_Days, averageDays2$Total_Number_Complaints,
         xlab = "Average Days",
         ylab = "Total Number of Complaints",
         main="Total Number of Complaints Alongside Average Number of Days to Close a Complaint",
         pch=19,
         col=averageDays2$Col,
         alpha=0.4,
         cex=2,
         ylim = c(-5000,16000),
         xlim = c(0,500),
         bty="n")
    #Legend Information
    text(395, 
         11000,
         "Average Days: ", 
         col="black",
         pos = 4,
         cex=.75)
    
    text(475, 
         11000,
         averageDays[1,input$complaint2],
         col="black",
         pos = 4,
         cex=.75)
    
    
    text(395, 
         12000,
         "Total # of Complaints: ",
         col="black",
         pos = 4,
         cex=.75 )
    
    text(475, 
         12000,
         averageDays[2,input$complaint2],
         col="black",
         pos = 4,
         cex=.75 )
    
    points(averageDays[1,input$complaint2], 
           averageDays[2,input$complaint2],
           pch=8,
           col="black",
           cex=4)
    
    segments(
      x0=400, x1=410, 
      y0=13500, 
      col="#e34a33",
      lty=1,
      lwd=5)
    
    text(
      415, 13500,
      "Detailed Complaint",
      col="#e34a33",
      pos = 4,
      cex= .75 ) 
    
    segments(
      x0=400, x1=410, 
      y0=14500, 
      col="#fdbb84",
      lty=1,
      lwd=5)
    
    text(
      415, 14500,
      "Medium Detailed Complaint",
      col="#fdbb84",
      pos = 4,
      cex = .75)
    
    segments(
      x0=400, x1=410, 
      y0=15500, 
      col="#fee8c8",
      lty=1,
      lwd=5)
    
    text(
      415, 15500,
      "General Complaint",
      col="#fdbb84",
      pos = 4,
      cex=.75)
    
    abline(h=seq(from=0,to=15000,by=2500),
           v=seq(from=0,to=400,by=50),
           col = "antiquewhite3",
           lty=3)
  })
  #Plots for Tab 2: Violation Frequency
  #Time Series Plot
  output$complaintFreq <- renderPlot({
    
    dat.sub <- dat[ dat$Complaint.Type == input$violation, ]
    complaint.sub <- tapply( dat.sub$Complaint.Type, dat.sub$month.year, length )
    complaint.sub[ is.na(complaint.sub) ] <- 0
    pretty.names <- format( as.Date(names(complaint.sub)), "%b-%Y" )
    month.labels <- format( as.Date(names(complaint.sub)), "%b" )
    
    plot( complaint.sub, type="b", pch=19, xaxt="n", bty="n" , main= input$violation, col="dodgerblue4", lwd=2)
    axis( side=1, at=(1:length(complaint.sub))[c(T,F,F)], labels=pretty.names[c(T,F,F)], cex.axis=0.5, las=2 )
    text( 1:length(complaint.sub), complaint.sub, month.labels, pos=3, cex=0.5 )
  })
  
  #Plots for Tab 3: Violation Locations
  #Map for All Open Violations
  output$map1 <- renderPlot({
    
    syr.map + geom_point(data=open.violations, aes(x=open.violation$lon, y=open.violations$lat), size=3, col="chocolate1", alpha=.4)
    
    })
  #Map for Open Violations by Vacancy 
  output$map2 <- renderPlot({
      
    syr.map + geom_point(data=open.violations, aes(x=open.violations$lon, y=open.violations$lat, col=vacancy), size=3)
    
    })
   #Map for Open Violations by Land Use Type
   output$map3 <- renderPlot({
      
     syr.map + geom_point(data=open.violations, aes(x=open.violations$lon, y=open.violations$lat, col=landtype), size=3)
    
    
  })
  
})
