
library(shiny)
library(dplyr)
library(ggplot2)

shinyServer(function(input, output) {
    
    # make data available to the app
    stl_excise_establishments <- read_csv("excise-establishments.csv") %>% 
        janitor::clean_names()
    
    output$statusBarPlot <- renderPlot({
        
        by_status_code <- stl_excise_establishments %>% 
          count(status_code)
      
        if (input$bar_order == "Ascending") {
          status_bar_plot <- by_status_code %>% 
            mutate(status_code = fct_reorder(status_code, n)) %>% 
            ggplot(aes(status_code, n)) +
            geom_col() 
        } else if (input$bar_order == "Descending") {
          status_bar_plot <- by_status_code %>% 
            mutate(status_code = fct_reorder(status_code, n, .desc = TRUE)) %>% 
            ggplot(aes(status_code, n)) +
            geom_col()
        } else {
          status_bar_plot <- stl_excise_establishments %>% 
            ggplot(aes(status_code)) +
            geom_bar()
        }
      
        status_bar_plot +
            labs(x = "Status",
                 y = "# of establishments")
    })
    
})
