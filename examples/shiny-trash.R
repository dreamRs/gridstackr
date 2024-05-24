
library(shiny)
library(bslib)
library(gridstackr)

ui <- page_fluid(
  tags$h2("GridStack trash example"),
 fluidRow(
   column(
     width = 3,
     gs_trash(id = "mytrash", label = "Drag here to remove")
   ),
   column(
     width = 9,
     gridstackOutput("mygrid")
   )
 )
)

server <- function(input, output, session) {

  output$mygrid <- renderGridstack({
    gridstack(
      trash_id = "mytrash",
      gs_item("1", id = "item_1", w = 4, h = 2, class_content = "gs-item-example"),
      gs_item("2", id = "item_2", w = 5, class_content = "gs-item-example"),
      gs_item("3", id = "item_3", w = 5, x = 4, y = 2, class_content = "gs-item-example"),
      gs_item("4", id = "item_4", h = 2, w = 3, class_content = "gs-item-example"),
      gs_item("5", id = "item_5", w = 6, x = 0, y = 3, class_content = "gs-item-example"),
      gs_item("6", id = "item_6", w = 6, x = 6, y = 3, class_content = "gs-item-example")
    )
  })

}

if (interactive())
  shinyApp(ui, server)
