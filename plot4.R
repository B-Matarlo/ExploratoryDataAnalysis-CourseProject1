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

# adding datetime column
power <- power %>%
  mutate(dttm = make_datetime(
    as.integer(substr(Date,1,4)),
    as.integer(substr(Date,6,7)),
    as.integer(substr(Date,9,10)),
    as.integer(substr(Time,1,2)),
    as.integer(substr(Time,4,5))
  )
  )

# plot 4

png(file="plot4.png")
par(mfrow=c(2,2))

# top left

with(power, plot(dttm, Global_active_power, type="l",
                 ylab="Global Active Power (kilowatts)", xlab=""))

# top right

with(power, plot(dttm, Voltage, type="l",
                 ylab="Voltage", xlab="datetime"))

# bottom left

with(power, plot(dttm, Sub_metering_1, type="l",
                 ylab="Energy sub metering", xlab=""))
with(power, lines(dttm, Sub_metering_2, col="red"))
with(power, lines(dttm, Sub_metering_3, col="blue"))
legend("topright", 
       c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"), 
       col= c("black","red", "blue"), lty=1, bty="n")

# bottom right
with(power, plot(dttm, Global_reactive_power, type="l",
                 ylab="Global_reactive_power", xlab="datetime"))

dev.off()
