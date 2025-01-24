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

# Read the data from the file
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

# Create the plot and save it as "plot2.png"
png("plot2.png", width = 480, height = 480)  # Open a graphics device to save the plot as a PNG file

# Plot with datetime on the X-axis
plot(
  filteredPowerData$Global_active_power ~ filteredPowerData$datetime,
  type = "l",  # "l" creates a line plot
  xlab = "",   # No label for the X-axis
  ylab = "Global Active Power (kilowatts)",  # Y-axis label
  xaxt = "n",   # Disable the default X-axis
  xlim = c(min(filteredPowerData$datetime), upperLimit) # Set the lower and upper x-axis limits
)

# Set the X-axis with days of the week
axis.POSIXct(1, at = seq(min(filteredPowerData$datetime), upperLimit, by = "days"), format = "%a")

# Close the graphics device
dev.off()

