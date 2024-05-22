
library(shiny)
library(ggplot2)
library(gridstackr)

ui <- fluidPage(
  tags$h2("GridStack example"),
  gridstackOutput("mygrid"),
  actionButton("go", "GO")
)

server <- function(input, output, session) {

  output$mygrid <- renderGridstack({
    gridstack(options = list(minRow = 2))
  })

  observeEvent(input$go, {
    session$sendCustomMessage(
      "gridstackr-add-widget",
      list(
        id = "mygrid",
        options = list(
          content = htmltools::doRenderTags(tags$div(
            id = paste0("container-", input$go),
            style = "width: 100%; height: 100%;"
          )),
          w = 2,
          h = 2
        )
      )
    )
    insertUI(
      selector = paste0("#container-", input$go),
      ui = renderPlot({
        ggplot(mtcars) + geom_point(aes(mpg, disp))
      }, outputArgs = list(width = "100%", height = "100%"))
    )
  })

}

shinyApp(ui, server)
