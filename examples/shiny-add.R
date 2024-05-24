
library(shiny)
library(bslib)
library(ggplot2)
library(gridstackr)

ui <- page_fluid(
  tags$h2("Add items GridStack example"),
  gridstackOutput("mygrid"),
  actionButton("add_plot1", "Add plot 1"),
  actionButton("add_plot2", "Add plot 2"),
  actionButton("add_plot3", "Add plot 3"),
  actionButton("add_plot4", "Add plot 4")
)

server <- function(input, output, session) {

  output$mygrid <- renderGridstack({
    gridstack(minRow = 2)
  })

  observeEvent(input$add_plot1, {
    p1 <- ggplot(mtcars) + geom_point(aes(mpg, disp))
    gs_proxy_add("mygrid",  p1, list(w = 2, h = 2))
  })

  observeEvent(input$add_plot2, {
    p2 <- ggplot(mtcars) + geom_boxplot(aes(gear, disp, group = gear))
    gs_proxy_add("mygrid", p2, list(w = 2, h = 2, x = 0, y = 2))
  })

  observeEvent(input$add_plot3, {
    p3 <- ggplot(mtcars) + geom_smooth(aes(disp, qsec))
    gs_proxy_add("mygrid", p3, list(w = 2, h = 2))
  })

  observeEvent(input$add_plot4, {
    p4 <-ggplot(mtcars) + geom_bar(aes(carb))
    gs_proxy_add("mygrid", p4, list(w = 2, h = 2))
  })

}

if (interactive())
  shinyApp(ui, server)
