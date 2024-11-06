library(tidyverse)   
library(shiny)

gpmdata <- read_csv("Gapminder_data.csv")

# user interface
ui4 <- fluidPage(
  
  # application title
  titlePanel("Gapminder Scatterplots"),
  
  sidebarLayout(
    sidebarPanel(
      
      # input for year
      sliderInput(inputId = "year",
                  label = "Year:",
                  min = 1800,
                  max = 2020,
                  value = 1800), 
      
      # input to select x-axis variable
      varSelectInput(inputId = "xvar", 
                     label = "Select Variable to Display on x-axis", 
                     data = gpmdata %>% dplyr::select(lifeExp, pop, gdpPercap)),
      
      # input to select y-axis variable
      varSelectInput(inputId = "yvar", 
                     label = "Select Variable to Display to y-axis", 
                     data = gpmdata %>% dplyr::select(lifeExp, pop, gdpPercap)),
      
      # input to select 'size' variable
      varSelectInput(inputId = "sizevar", 
                     label = "Select Variable to Display by Size", 
                     data = gpmdata %>% dplyr::select(lifeExp, pop, gdpPercap))
    ),
    
    # show plot
    mainPanel(
      plotOutput("plot")
    )
  )
)


# server logic
server4 <- function(input, output) {
  
  output$plot <- renderPlot({
    
    # create plot
    ggplot(data = gpmdata %>% filter(year == input$year)) + 
      geom_point(aes(x = !!input$xvar, y = !!input$yvar, color = continent, size = !!input$sizevar)) +
      scale_x_continuous(trans='log2')
  })
}


# run the application 
shinyApp(ui = ui4, server = server4)