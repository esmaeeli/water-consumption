library(shiny)
fluidPage(
    titlePanel("Per Capita Consumption Based on Temperature in Select CA Water Districts"),
    sidebarLayout(
        sidebarPanel(
            p("Change the temperature to see the predicted levels of consumption for each water districts"),
            p("Note: Districts which don't experience this monthly average temperature are shown in grey."),
            sliderInput("temperature",
                        "Temperature (F)",
                        min=45, max=85, value=65
            )            
        ),
        
        mainPanel(
            plotOutput(outputId="consumptionPlot"),
            HTML('<footer>
                    "In terms of predictive power, this map represents data from two years, a period of time when California water districts were mandated to cut use by 25%. Data was extracted from 170 of the approximate 400 reporting districts in the state."
                    </footer>')        
        )
    )
)