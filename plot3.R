library(data.table)
library(reshape2)

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

# Subset the column required for the plot and melt it
pcdata2<-subset(pcdata1,select=Sub_metering_1:DateTime)
pcdata2$DateTime<-as.character(pcdata2$DateTime)
meltedData<-melt(pcdata2,id.vars="DateTime")
meltedData$DateTime<-strptime(meltedData$DateTime,"%Y-%m-%d %H:%M:%S")

# Plot the data
png("plot3.png",width=480,height=480,units="px")
plot(meltedData$DateTime,meltedData$value,type="n",xlab="",ylab="Energy sub metering")
legend("topright",legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),col=c("black","red","blue"),lty="solid")
points(meltedData$DateTime[meltedData$variable=="Sub_metering_1"],meltedData$value[meltedData$variable=="Sub_metering_1"],type="l")
points(meltedData$DateTime[meltedData$variable=="Sub_metering_2"],meltedData$value[meltedData$variable=="Sub_metering_2"],type="l",col="red")
points(meltedData$DateTime[meltedData$variable=="Sub_metering_3"],meltedData$value[meltedData$variable=="Sub_metering_3"],type="l",col="blue")
dev.off()