
library(shiny)
library(dplyr)
library(ggplot2)


shinyServer(function(input, output) {

    # make the data available to the app
    stl_excise_establishments <- readr::read_csv("excise-establishments.csv") %>% 
        janitor::clean_names()
    
    output$statusBarPlot <- plotly::renderPlotly({

        by_status_code <- stl_excise_establishments %>% 
            count(status_code) 
        
        if (input$bar_order == "Ascending") {
            status_bar_plot <- by_status_code %>% 
                mutate(status_code = forcats::fct_reorder(status_code, n)) %>% 
                ggplot(aes(status_code, n)) +
                geom_col()
        } else if (input$bar_order == "Descending") {
            status_bar_plot <- by_status_code %>% 
                mutate(status_code = forcats::fct_reorder(status_code, n, .desc = TRUE)) %>% 
                ggplot(aes(status_code, n)) +
                geom_col()
        } else {
            status_bar_plot <- by_status_code %>% 
                ggplot(aes(status_code, n)) +
                geom_col()
        }
         
        status_bar_plot +
            labs(x = "Status",
                 y = "# of establishments")

    })
    
    output$neighborhoodBarPlot <- plotly::renderPlotly({
        
        stl_excise_establishments %>% 
            filter(!is.na(neighborhood_name),
                   status_code %in% input$status_display) %>% 
            mutate(neighborhood_name = forcats::fct_lump(neighborhood_name, input$number_of_neighborhoods)) %>% 
            ggplot(aes(forcats::fct_rev(forcats::fct_infreq(neighborhood_name)), fill = status_code)) +
            geom_bar() +
            coord_flip() + 
            labs(x = "Neighborhood name",
                 y = "# of establishments")
        
    })
    
    output$exciseTable <- DT::renderDataTable({
        
        stl_excise_establishments %>% 
            mutate_if(is.character, as.factor) %>% 
            DT::datatable(rownames = FALSE,
                          colnames = c("Business name",
                                       "Case number",
                                       "Doing business as",
                                       "Location",
                                       "Neighborhood name",
                                       "Police District",
                                       "Status code",
                                       "Ward"),
                          filter = "top")
        
    })

})
