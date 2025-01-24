# Load necessary library
library("data.table")

# Define file and directory paths
zipUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zipFile <- "dataset.zip"
dataFile <- "household_power_consumption.txt"

# Download the zip file if it doesn't exist
if (!file.exists(zipFile)) {
  download.file(zipUrl, zipFile, mode = "wb")
  message("Zip file downloaded.")
} else {
  message("Zip file already exists. Skipping download.")
}

# Unzip the file if the data file doesn't exist
if (!file.exists(dataFile)) {
  unzip(zipFile)
  message("Data file extracted.")
} else {
  message("Data file already exists. Skipping extraction.")
}

# Read data from file
powerData <- data.table::fread(input = dataFile, na.strings = "?")

# Convert the "Date" column to Date type
powerData[, Date := as.Date(Date, format = "%d/%m/%Y")]

# Filter for the dates 2007-02-01 and 2007-02-02
filteredPowerData <- powerData[Date %in% as.Date(c("2007-02-01", "2007-02-02"))]

# Combine the Date and Time into a single datetime column
Datetime <- paste(as.Date(filteredPowerData$Date), filteredPowerData$Time)
filteredPowerData$datetime <- as.POSIXct(Datetime)

# Set locale to English to display weekdays in English
Sys.setlocale("LC_TIME", "English")

# Set an upper limit for the x-axis (e.g., 2007-02-03)
upperLimit <- as.POSIXct("2007-02-03 00:00:00")

# Ensure Sub_metering columns are numeric, and remove any non-numeric entries (e.g., NAs)
filteredPowerData$Sub_metering_1 <- as.numeric(filteredPowerData$Sub_metering_1)
filteredPowerData$Sub_metering_2 <- as.numeric(filteredPowerData$Sub_metering_2)
filteredPowerData$Sub_metering_3 <- as.numeric(filteredPowerData$Sub_metering_3)

# Handle any NAs in Sub_metering columns (if needed)
filteredPowerData <- na.omit(filteredPowerData)

# Create the plots
png("plot4.png", width = 480, height = 480)
par(mfrow = c(2, 2))

# 1st plot
plot(
  filteredPowerData$Global_active_power ~ filteredPowerData$datetime,
  type = "l",  # "l" creates a line plot
  xlab = "",   # No label for the X-axis
  ylab = "Global Active Power (kilowatts)",  # Y-axis label
  xaxt = "n",   # Disable the default X-axis
  xlim = c(min(filteredPowerData$datetime), upperLimit)  # Set the lower and upper x-axis limits
)
axis.POSIXct(1, at = seq(min(filteredPowerData$datetime), upperLimit, by = "days"), format = "%a")

# 2nd plot
plot(
  filteredPowerData$datetime,
  as.numeric(filteredPowerData$Voltage),
  type = "l", xlab = "datetime",
  ylab = "Voltage",
  xaxt = "n",   # Disable the default X-axis
  xlim = c(min(filteredPowerData$datetime), upperLimit)  # Set the lower and upper x-axis limits
)
axis.POSIXct(1, at = seq(min(filteredPowerData$datetime), upperLimit, by = "days"), format = "%a")

# 3rd plot
with(filteredPowerData, {
  plot(Sub_metering_1 ~ datetime,
       type = "l", 
       ylab = "Energy sub metering", 
       xlab = "",
       xaxt = "n",   # Disable the default X-axis
       xlim = c(min(filteredPowerData$datetime), upperLimit)  # Set the lower and upper x-axis limits
  )
  lines(Sub_metering_2 ~ datetime, col = 'Red')
  lines(Sub_metering_3 ~ datetime, col = 'Blue')
})
legend("topright", col = c("black", "red", "blue"), lty = 1, lwd = 2, legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
axis.POSIXct(1, at = seq(min(filteredPowerData$datetime), upperLimit, by = "days"), format = "%a")

# 4th plot
plot(
  filteredPowerData$datetime,
  as.numeric(filteredPowerData$Global_reactive_power),
  type = "l", xlab = "datetime",
  ylab = "Global_reactive_power",
  xaxt = "n",   # Disable the default X-axis
  xlim = c(min(filteredPowerData$datetime), upperLimit)  # Set the lower and upper x-axis limits
)
axis.POSIXct(1, at = seq(min(filteredPowerData$datetime), upperLimit, by = "days"), format = "%a")

dev.off()

