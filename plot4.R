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

# Renders and decorates 4 plots in a 2x2 layout 
# the plots are Global Active Power vs time,
# Voltage vs Time
# Energy sub metering vs Time
# Global reactive power vs Time
doPlot <- function() {
  data <- loadData()
  with(df, {
    par(mfrow=c(2,2))
    plot(Time, Global_active_power, main="", type="l", ylab="Global Active Power (kilowatts)", xlab="")
    plot(Time, Voltage, type="l", xlab="datetime")
    plot(Time, Sub_metering_1, main="", type="l", ylab="Energy sub metering", xlab="")
    lines(Time, Sub_metering_2, col="red")
    lines(Time, Sub_metering_3, col="blue")
    legend("top", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col=c("black", "red", "blue"), bty = "n", lwd=2, cex=0.8)
    plot(Time, Global_reactive_power, type="l", xlab="datetime")
  })
}

# Copies the plot to a file device
toFile <- function() {
  dev.copy(png, file="plot4.png", width=480, height=480)
  dev.off()
}

library("sqldf") # Load required library
doPlot() # Generate plot
toFile() # Copy plot to png file