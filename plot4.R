library( tidyverse )
library( lubridate )

# 1. Download Data
# 1.1 Create data directory

if( !dir.exists( "data" )) { dir.create("data") }

# 1.2 Download and unzip data file

file.url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
file.path <- "data/household_power_consumption.zip"
file.unzip <- "data/household_power_consumption.txt"

if( !file.exists( file.path ) & !file.exists( file.unzip )) {
  download.file( file.url, file.path )
  unzip( file.path, exdir = "data" )
}

# 2. Load and filter data 
# 2.1 Load data into memory
data <- read_delim( "data/household_power_consumption.txt", 
                    delim = ";", 
                    col_types = list( col_date( format = "%d/%m/%Y" ),
                                      col_time( format = "" ),
                                      col_number(),
                                      col_number(),
                                      col_number(),
                                      col_number(),
                                      col_number(),
                                      col_number(),
                                      col_number()))

# 2.2 Filter and retain correct dates
data = filter( data, data$Date == as.Date( "2007-02-01" ) | data$Date == as.Date( "2007-02-02" ))

# 2.3 Combine date and time
data <- mutate( data, DateTime = ymd_hms( paste( Date, Time )))

# 3. Create and save plot
png( "plot4.png", width = 480, height = 480 )

par( mfrow = c( 2, 2 ))

# 3.1 Plot 1 - top left
plot( Global_active_power ~ DateTime, data, type = "l", xlab = NA, ylab = "Global Active Power", xaxt = "n" )
axis( 1, at = pretty( data$DateTime, n = 2 ), labels = c( "Thu", "Fri", "Sat" ))

# 3.2 Plot 2 - top right
plot( Voltage ~ DateTime, data, type = "l", xlab = "datetime", ylab = "Voltage", xaxt = "n" )
axis( 1, at = pretty( data$DateTime, n = 2 ), labels = c( "Thu", "Fri", "Sat" ))

# 3.3 Plot 3 - bottom left
plot( Sub_metering_1 ~ DateTime, data, type = "l", xlab = NA, ylab = "Energy sub metering", xaxt = "n" )
lines( Sub_metering_2 ~ DateTime, data, type = "l", col = "red" )
lines( Sub_metering_3 ~ DateTime, data, type = "l", col = "blue" )

axis( 1, at = pretty( data$DateTime, n = 2 ), labels = c( "Thu", "Fri", "Sat" ))

legend( "topright", col = c( "black", "red", "blue"), legend = c( "Sub_metering_1", "Sub_metering_2", "Sub_metering_3" ), lty = 1, bty = "n" )

# 3.4 Plot 4 - bottom right
plot( Global_reactive_power ~ DateTime, data, type = "l", xlab = "datetime", xaxt = "n" )
axis( 1, at = pretty( data$DateTime, n = 2 ), labels = c( "Thu", "Fri", "Sat" ))

# 3.5 Save plot as png and close
dev.off()