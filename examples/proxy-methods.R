
library(shiny)
library(bslib)
library(gridstackr)

ui <- page_fluid(
  tags$h2("GridStack Input example"),
  gridstackOutput("mygrid"),
  actionButton("compact", "Compact"),
  actionButton("enable", "Enable"),
  actionButton("disable", "Disable"),
  actionButton("enableMove", "Enable Move"),
  actionButton("disableMove", "Disable Move"),
  actionButton("enableResize", "Enable Resize"),
  actionButton("disableResize", "Disable Resize")
)

server <- function(input, output, session) {

  output$mygrid <- renderGridstack({
    gridstack(
      minRow = 2,
      margin = "0.2rem",
      gs_item("1", id = "item_1", w = 2, h = 2, class_content = "gs-item-example"),
      gs_item("2", id = "item_2", w = 4, class_content = "gs-item-example"),
      gs_item("3", id = "item_3", w = 1, x = 4, y = 2, class_content = "gs-item-example"),
      gs_item("4", id = "item_4", h = 2, w = 2, class_content = "gs-item-example"),
      gs_item("5", id = "item_5", w = 2, h = 1, x = 0, y = 3, class_content = "gs-item-example"),
      gs_item("6", id = "item_6", w = 3, x = 7, y = 3, class_content = "gs-item-example")
    )
  })

  observeEvent(input$compact, gs_proxy_compact("mygrid"))
  observeEvent(input$enable, gs_proxy_enable("mygrid"))
  observeEvent(input$disable, gs_proxy_disable("mygrid"))
  observeEvent(input$enableMove, gs_proxy_enable_move("mygrid", TRUE))
  observeEvent(input$disableMove, gs_proxy_enable_move("mygrid", FALSE))
  observeEvent(input$enableResize, gs_proxy_enable_resize("mygrid", TRUE))
  observeEvent(input$disableResize, gs_proxy_enable_resize("mygrid", FALSE))

}

if (interactive())
  shinyApp(ui, server)
