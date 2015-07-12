# Loads filtered data by fixed date
# Parses date and times columns
# Changes "?" to NA
library("sqldf")
loadData <- function() {
  con <- file("../household_power_consumption.txt")
  df <- read.csv.sql("household_power_consumption.txt", "select * from con where Date in ('1/2/2007', '2/2/2007')", header=TRUE, sep=";")
  df$Date <- as.Date(df$Date, format="%d/%m/%Y")
  df$Time <- strptime(paste(df$Date, df$Time), format="%d/%m/%Y %H:%M:%S")
  close(con)
  df
}

# Renders and decorates a hist plot 
# over Global_active_power
doPlot <- function() {
  data <- loadData()
  hist(df$Global_active_power, main="Global Active Power", xlab="Global Active Power (kilowatts)", col="red")
}

# Copies the plot to a file device
toFile <- function() {
  dev.copy(png, file="plot1.png", width=480, height=480)
  dev.off()
}

library("sqldf") # Load required library
doPlot() # Generate plot
toFile() # Copy plot to png file