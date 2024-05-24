
library(shiny)
library(bslib)
library(gridstackr)

ui <- page_fluid(
  tags$h2("GridStack Input example"),
  gridstackOutput("mygrid"),
  verbatimTextOutput("res")
)

server <- function(input, output, session) {

  output$mygrid <- renderGridstack({
    gridstack(
      options = list(minRow = 2, margin = "0.2rem"),
      gs_item("1", id = "item_1", w = 4, h = 2, class_content = "gs-item-example"),
      gs_item("2", id = "item_2", w = 5, class_content = "gs-item-example"),
      gs_item("3", id = "item_3", w = 5, x = 4, y = 2, class_content = "gs-item-example"),
      gs_item("4", id = "item_4", h = 2, w = 3, class_content = "gs-item-example"),
      gs_item("5", id = "item_5", w = 6, x = 0, y = 3, class_content = "gs-item-example"),
      gs_item("6", id = "item_6", w = 6, x = 6, y = 3, class_content = "gs-item-example")
    )
  })

  output$res <- renderPrint({
    data.table::rbindlist(input$mygrid_layout$children, fill = TRUE)
  })

}

if (interactive())
  shinyApp(ui, server)
