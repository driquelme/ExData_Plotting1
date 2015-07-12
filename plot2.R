# Loads filtered data by fixed date
# Parses date and times columns
# Changes "?" to NA
loadData <- function() {
  con <- file("../household_power_consumption.txt")
  df <- read.csv.sql("household_power_consumption.txt", "select * from con where Date in ('1/2/2007', '2/2/2007')", header=TRUE, sep=";")
  df$Date <- as.Date(df$Date, format="%d/%m/%Y")
  df$Time <- strptime(paste(df$Date, df$Time), format="%d/%m/%Y %H:%M:%S")
  close(con)
  df
}

# Renders and decorates a lines plot 
# showing Global_active_power vs Time
doPlot <- function() {
  data <- loadData()
  with(df, plot(Time, Global_active_power, main="", type="l", ylab="Global Active Power (kilowatts)", xlab=""))
}

# Copies the plot to a file device
toFile <- function() {
  dev.copy(png, file="plot2.png", width=480, height=480)
  dev.off()
}

library("sqldf") # Load required library
doPlot() # Generate plot
toFile() # Copy plot to png file