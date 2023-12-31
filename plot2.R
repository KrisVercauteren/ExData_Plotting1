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
# 3.1 Create plot, and adding some additional manipulation as by default weekdays were not shown on the plot
plot( data$Global_active_power ~ data$DateTime, type = "l", xlab = NA, ylab = "Global Active Power (kilowatts)", xaxt = "n" )
axis( 1, at = pretty( data$DateTime, n = 2 ), labels = c( "Thu", "Fri", "Sat" ))

# 3.2 Save plot as png and close
dev.copy( png, "plot2.png", width  = 480, height = 480 )
dev.off()
