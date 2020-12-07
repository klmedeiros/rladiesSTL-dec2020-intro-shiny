
library(shiny)

shinyUI(fluidPage(
    
    # Application title
    titlePanel("STL Excise Establishments"),

    # sidebar 
    sidebarLayout(
        sidebarPanel(
            selectInput("bar_order",
                        "Order of bars:",
                        choices = c("Alphabetical (default)",
                                    "Ascending",
                                    "Descending"))
        ),

        # main panel
        mainPanel(
            plotOutput("statusBarPlot")
        )
    )
))
