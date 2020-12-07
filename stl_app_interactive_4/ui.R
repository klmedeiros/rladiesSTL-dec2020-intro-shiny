
library(shiny)

shinyUI(fluidPage(
    
    # Application title
    titlePanel("STL Excise Establishments"),

    sidebarLayout(
        sidebarPanel(
            selectInput("bar_order",
                        "Order of bars:",
                        choices = c("Alphabetical (default)",
                                    "Ascending",
                                    "Descending")),
            sliderInput("neighborhoods",
                        "Number of neighborhoods to display (besides Other):",
                        min = 1,
                        max = 15,
                        value = 6,
                        step = 1),
            checkboxGroupInput("status_codes",
                               "Status of establishment:",
                               choices = c("Closed" = "CLOSED",
                                           "Active" = "ACTIVE",
                                           "Open" = "OPEN",
                                           "Cancelled" = "CANCELLED",
                                           "Renewal" = "RENEWAL" ),
                               selected = c("CLOSED", "ACTIVE", "OPEN", "CANCELLED", "RENEWAL"))
        ),

        mainPanel(
            tabsetPanel(
                tabPanel("Status Count", plotly::plotlyOutput("statusBarPlot")),
                tabPanel("Status by Neighborhood", plotly::plotlyOutput("statusNeighborhoodBarPlot")),
                tabPanel("Excise Establishments DT", DT::dataTableOutput("exciseEstablishmentsDT"))
            )
        )
    )
))
