library(dplyr)
library(data.table)
library(lubridate)

# get column names
powerNames <- fread("household_power_consumption.txt", header = T,
           nrows = 1)

# opened data file in text editor to find first line of 1/2/2007 entries
# one entry every minute
# data for all of 1/2/2007 and 2/2/2007 is thus
# 60*24*2
# read only subset of data
power <- fread("household_power_consumption.txt", header = F,
           skip = 66637, nrows = 60*24*2, na.strings = "?")

# labeling columns
colnames(power) <- colnames(powerNames)

# correcting column classes
power$Date <- dmy(power$Date)

power$Time <- hms(power$Time)

# plot 1

png(file="plot1.png")
hist(power$Global_active_power, col= "red", main = "Global Active Power")
dev.off()
