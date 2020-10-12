library(sqldf)
library(dplyr)
library(lubridate)
library(hms)

#Loading the data

setwd(dirname(rstudioapi::getSourceEditorContext()$path))

ifelse(!dir.exists(file.path(getwd(), "zip")), 
       dir.create(file.path(getwd(), "zip")), FALSE)

download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
              "zip/exdata_data_household_power_consumption.zip","curl")
unzip("zip/exdata_data_household_power_consumption.zip", 
      files = NULL, list = FALSE, overwrite = TRUE,
      junkpaths = FALSE, exdir = ".", unzip = "internal",
      setTimes = FALSE)

query_string <- 'select * from file where Date=="1/2/2007" or Date=="2/2/2007"'
df <- read.csv.sql(file = "household_power_consumption.txt", 
                   sql = query_string, 
                   sep = ";")
df$Date<-as.Date(strptime(df$Date,"%d/%m/%Y"))
df$Time <- as.hms(df$Time)
df$DateTime<-as.POSIXct(paste(df$Date, df$Time), format="%Y-%m-%d %H:%M")

grep("\\?",df$Global_active_power:df$Sub_metering_3) #check '?' as NA

#Plot 4
png(file="plot4.png")
par(mfcol=c(2,2),mar=c(4,3,1,1))
plot(df$DateTime,df$Global_active_power,type="l",cex.axis=0.9,xlab="",ylab="")
mtext(side=2,text="Global Active Power",line=2,cex=0.9)
plot(df$DateTime,df$Sub_metering_1,type="l",cex.axis=0.9,xlab="",ylab="")
lines(df$DateTime,df$Sub_metering_2,type="l",col="red")
lines(df$DateTime,df$Sub_metering_3,type="l",col="blue")
legend("topright",inset=0.02,legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       lwd=c(1,1,1),col=c("black","red","blue"),cex=0.9,box.lty=0)
mtext(side=2,text="Energy sub metering",line=2,cex=0.9)
plot(df$DateTime,df$Voltage,type="l",
     ylab="Voltage",xlab="",
     cex.lab=0.9,cex.axis=0.9)
mtext(side=1,text="datetime",line=2,cex=0.9)
mtext(side=2,text="Voltage",line=2,cex=0.9)
plot(df$DateTime,df$Global_reactive_power,type="l",
     ylab="Global_reactive_power",xlab="",
     cex.lab=0.9,cex.axis=0.9)
mtext(side=1,text="datetime",line=2,cex=0.9)
mtext(side=2,text="Global_reactive_power",line=2,cex=0.9)
dev.off()
