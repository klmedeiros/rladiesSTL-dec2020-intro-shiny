
library(shiny)


shinyUI(fluidPage(

    # Application title
    titlePanel("STL Excise Establishments"),

    # select theme
    # shinythemes::themeSelector(),
    theme = shinythemes::shinytheme("paper"),
    
    sidebarLayout(
        sidebarPanel(
            selectInput(inputId = "bar_order",
                        label = "Select the order for the bars:",
                        choices = c("Alphabetical",
                                    "Ascending",
                                    "Descending")),
            sliderInput(inputId = "number_of_neighborhoods",
                        label = "Choose the number of neighborhoods to display (besides Other):",
                        min = 1,
                        max = 15,
                        value = 6,
                        step = 1),
            checkboxGroupInput(inputId = "status_display",
                               label = "Choose which statuses to display in the plots:",
                               choices = c("Closed" = "CLOSED",
                                           "Active" = "ACTIVE",
                                           "Open" = "OPEN",
                                           "Cancelled" = "CANCELLED",
                                           "In Renewal" = "RENEWAL" ),
                               selected = c("CLOSED", "ACTIVE", "OPEN", "CANCELLED", "RENEWAL"))
        ),

        mainPanel(
            tabsetPanel(
                tabPanel("Status bar plot", plotly::plotlyOutput("statusBarPlot")),
                tabPanel("Neighborhood bar plot", plotly::plotlyOutput("neighborhoodBarPlot")),
                tabPanel("STL Excise Establishments DT", DT::dataTableOutput("exciseTable"))
            )
        )
    )
))
