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

# plot 2

png(file="plot2.png")
with(power, plot(dttm, Global_active_power, type="l",
                 ylab="Global Active Power (kilowatts)", xlab=""))
dev.off()
