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
data <- read.delim( "data/household_power_consumption.txt", sep = ";" )

# 2.2 Change the format of date and time
data[[ "Date" ]] <- as.Date( data[[ "Date" ]], format = "%d/%m/%Y" )

# 2.3 Filter and retain correct dates
data_retained = subset( data, data$Date == as.Date( "2007-02-01" ) | data$Date == as.Date( "2007-02-02" ))
data_retained[[ "Global_active_power" ]] <- as.numeric( data_retained[[ "Global_active_power" ]] )

# 3. Create and save plot
# 3.1 Create plot
hist( data_retained$Global_active_power, col = "red", xlab = "Global Active Power (kilowatts)", main = "Global Active Power" )

# 3.2 Save plot as png and close
dev.copy( png, "plot1.png", width  = 480, height = 480 )
dev.off()


