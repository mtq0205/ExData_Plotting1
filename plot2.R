# Download the data from the source and read it

temp<-tempfile()
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)
pcdata<-read.table(unz(temp,"household_power_consumption.txt"),sep=";",header=TRUE,na.strings="?")
unlink(temp)

# Remove NAs and create a new DateTime column with Date/Time class
# Subset the data for specific dates

pcdata<-na.omit(pcdata)
pcdata$Date<-as.Date(pcdata$Date,format="%d/%m/%Y")
pcdata1<-subset(pcdata,pcdata$Date==as.Date("2007-02-01")| pcdata$Date==as.Date("2007-02-02"))

pcdata1$DateTime<-paste(pcdata1$Date,pcdata1$Time,sep=" ")
pcdata1$DateTime<-strptime(pcdata1$DateTime,"%Y-%m-%d %H:%M:%S")

# Plot the data
png("plot2.png",width=480,height=480,units="px")
plot(pcdata1$DateTime,pcdata1$Global_active_power,type="l",ylab="Global Active Power (killowatts)",xlab="")
dev.off()