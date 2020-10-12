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

#Plot 1
png(file="plot1.png")
hist(df$Global_active_power,col="red",main="Global Active Power",
     xlab="Global Active Power (kilowatts)",cex.main=1.2,cex.lab=0.9,
     cex.axis=0.9)
#plot1<-recordPlot()
dev.off()