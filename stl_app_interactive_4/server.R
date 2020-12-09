
library(shiny)
library(dplyr)
library(ggplot2)

shinyServer(function(input, output) {
    
    # make data available to the app
    stl_excise_establishments <- read_csv("excise-establishments.csv") %>% 
        janitor::clean_names()
    
    output$statusBarPlot <- plotly::renderPlotly({
        
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
    
    
    output$statusNeighborhoodBarPlot <- plotly::renderPlotly({
        
        stl_excise_establishments %>% 
            filter(!is.na(neighborhood_name),
                   status_code %in% input$status_codes) %>% 
            mutate(neighborhoods_lumped = forcats::fct_lump(neighborhood_name, input$neighborhoods)) %>% 
            # count(neighborhoods_lumped) %>% 
            ggplot(aes(forcats::fct_rev(forcats::fct_infreq(neighborhoods_lumped)), fill = status_code)) +
            geom_bar() +
            coord_flip() + 
            labs(x = "Neighborhood name",
                 y = "# of establishments")
        
    })
    
    output$exciseEstablishmentsDT <- DT::renderDataTable({
        
        stl_excise_establishments %>% 
            mutate_if(is.character, as.factor) %>% 
            DT::datatable(rownames = FALSE,
                          colnames = c("Business name",
                                       "Case #",
                                       "Doing business as...",
                                       "Location",
                                       "Neighborhood name",
                                       "Most recent police district #",
                                       "Status code",
                                       "Ward"),
                          filter = "top")
        
    })
    
})
