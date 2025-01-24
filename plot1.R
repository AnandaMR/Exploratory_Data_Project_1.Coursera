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

# Create the histogram and save it as "plot1.png"
png("plot1.png", width = 480, height = 480)  # Open a graphics device to save the plot as a PNG file
# The width and height are set to 480 pixels as required for the project.

hist(
  filteredPowerData$Global_active_power,  # The column used to create the histogram
  col = "red",                            # Set the color of the bars to red
  main = "Global Active Power",           # Title of the histogram
  xlab = "Global Active Power (kilowatts)", # Label for the x-axis
  ylab = "Frequency"                      # Label for the y-axis
)

dev.off()  # Close the graphics device and save the file as "plot1.png"
