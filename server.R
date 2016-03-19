library(shiny)
library(dplyr)
library(ggplot2)

setwd("~/catdata/")

#Read data from previously cleaned data
CA=read.csv(file="https://github.com/esmaeeli/water-consumption.git/data/CA_fort.csv")
district=read.csv(file="https://github.com/esmaeeli/water-consumption.git/data/district_fort.csv")
temperatureConsumption=read.csv(file="https://github.com/esmaeeli/water-consumption.git/data/temperatureConsumption.csv")

function(input, output) {
    output$consumptionPlot=renderPlot({        
        selectedTemp=input$temperature
        #Convert Fahrenheit to Celsius (our model uses Celsius)
        selectedTemp=(selectedTemp-32)/1.8
        fit=lm(consumption_gpcd~temp+districtName,data=temperatureConsumption)
        temperatureConsumption$predict=predict(fit,data.frame(temp=selectedTemp,districtName=temperatureConsumption$districtName))
        consumption=temperatureConsumption %>% 
            group_by(districtName) %>% 
            summarise(consumptionPredict=mean(predict),minTemp=min(temp),maxTemp=max(temp)) %>%
            mutate(consumptionPredict=ifelse(selectedTemp>=minTemp & selectedTemp<=maxTemp,consumptionPredict,NA))                
        districtConsumption=inner_join(district,consumption,by="districtName")  
        
        #Create the plot
        ggplot(CA)+aes(x=long,y=lat,group=group)+geom_polygon(color="black",fill="white")+
        geom_polygon(data=districtConsumption,aes(x=long,y=lat,group=group,fill=consumptionPredict))+
        scale_fill_gradient(name="Consumption(gpcd)",limits=c(20,300),low="green",high="red", na.value = "grey")
    })
}
