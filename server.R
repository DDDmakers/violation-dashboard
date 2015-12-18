##Server App

#set location

#load libraries
library(shiny)
library(ggmap)

#functions for maps
open.violations <- read.csv("Data/openviolations.csv")
syracuse <- get_map(location="Syracuse NY", zoom = 13, color="bw")
syr.map <- ggmap(syracuse, extent = "device")


#functions for closeout
closedViolations <- read.csv("Data/ComplaintsDays.csv", stringsAsFactors = F)
averageDays <- read.csv("Data/AverageDays.csv", stringsAsFactors = F)
averageDays2 <- read.csv("Data/AverageDays2.csv", stringsAsFactors = F)

#functions before Server begins for Frequency
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

shinyServer(function(input, output, sessions) {

  #Plot 1 for Violation Closeout Tab  
  output$complaintPlot <- renderPlot({
    hist(closedViolations[,input$complaint],
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
    #Plot 2 for Violation Closeout Tab  
  output$stats <- renderPrint({
    summary(closedViolations[,input$complaint])
  })
  #Summary Statistics of All Complaints for First Tab
  output$stats2 <- renderPrint({
    summary(closedViolations$AllComplaints)
  })
  
  #Summary Statistics for Chosen Complaint First Tab
  output$averagesPlot <- renderPlot({
    
    
    plot(averageDays2$Average_Days, averageDays2$Total_Number_Complaints,
         xlab = "Average Days",
         ylab = "Total Number of Complaints",
         main="Total Number of Complaints Alongside Average Number of Days to Close a Complaint",
         pch=19,
         col=averageDays2$Col,
         cex=2,
         ylim = c(-5000,16000),
         xlim = c(0,500),
         bty="n")
    
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
 
  ##Plot for Violation Frequency Tab
  output$complaintFreq <- renderPlot({
    
    dat.sub <- dat[ dat$Complaint.Type == input$violation, ]
    complaint.sub <- tapply( dat.sub$Complaint.Type, dat.sub$month.year, length )
    complaint.sub[ is.na(complaint.sub) ] <- 0
    pretty.names <- format( as.Date(names(complaint.sub)), "%b-%Y" )
    month.labels <- format( as.Date(names(complaint.sub)), "%b" )
    
    plot( complaint.sub, type="o", pch=19, xaxt="n", bty="n" , main= input$violation, col="dodgerblue1", lwd=2)
    axis( side=1, at=(1:length(complaint.sub))[c(T,F,F)], labels=pretty.names[c(T,F,F)], cex.axis=0.5, las=2 )
    text( 1:length(complaint.sub), complaint.sub, month.labels, pos=3, cex=0.7 )
  })
  
  ##Plots for Maps Tab
  output$map1 <- renderPlot({
    
    syr.map + geom_point(data=open.violations, aes(x=lon, y=lat), size=3, col="chocolate1", alpha=.4)
    
    })
    
  output$map2 <- renderPlot({
      

    syr.map + geom_point(data=open.violations, aes(x=lon, y=lat, col=open.violations$VacantBuilding), size=2)
    
    })
    
   output$map3 <- renderPlot({
    syr.map + geom_point(data=open.violations, aes(x=lon, y=lat, col=open.violations$LandUse), size=2)
    
  })
  
})
