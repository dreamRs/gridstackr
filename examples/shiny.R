
library(shiny)
library(ggplot2)
library(gridstackr)

ui <- fluidPage(
  tags$h2("GridStack example"),
  gridstack(
    options = list(minRow = 2),
    gs_item(plotOutput("plot1", height = "100%"), w = 4),
    gs_item(plotOutput("plot2", height = "100%"), w = 4),
    gs_item(plotOutput("plot3", height = "100%"), w = 4),
    gs_item(plotOutput("plot4", height = "100%"), w = 12)
  )
)

server <- function(input, output, session) {

  output$plot1 <- renderPlot({
    ggplot(mtcars) + geom_point(aes(mpg, disp))
  })
  output$plot2 <- renderPlot({
    ggplot(mtcars) + geom_boxplot(aes(gear, disp, group = gear))
  })
  output$plot3 <- renderPlot({
    ggplot(mtcars) + geom_smooth(aes(disp, qsec))
  })
  output$plot4 <- renderPlot({
    ggplot(mtcars) + geom_bar(aes(carb))
  })

}

shinyApp(ui, server)
