library(shiny)
library(bslib)
library(ggplot2)
library(gridstackr)
library(sortable)

ui <- page_fillable(
  tags$h2("GridStack example"),
  layout_sidebar(
    sidebar = sidebar(
      width = 300,
      gridstackOutput("bucket")
    ),
    gs_trash(id = "mytrash", label = "Drag here to remove", height = "50px"),
    gridstackOutput("dashboard")
  )
)

server <- function(input, output, session) {

  output$bucket <- renderGridstack({
    gridstack(
      disableResize = TRUE,
      column = 1,
      options = list(
        acceptWidgets = TRUE,
        dragOut = TRUE
      ),
      gs_item(
        selectInput(
          inputId = "variable",
          label = "Variable:",
          choices = c(
            "Cylinders" = "cyl",
            "Transmission" = "am",
            "Gears" = "gear"
          )
        ),
        tableOutput("data")
      ))
  })

  output$dashboard <- renderGridstack({
    gridstack(
      margin = "10px",
      cellHeight = "140px",
      resize_handles = "all",
      float = TRUE,
      options = list(
        acceptWidgets = TRUE
      ),
      trash_id = "mytrash"
    )
  })

  observeEvent(input$dashboard_layout, {
    print(input$dashboard_layout)
  })

  output$data <- renderTable({
    mtcars[, c("mpg", input$variable), drop = FALSE]
  }, rownames = TRUE)

}

if (interactive())
  shinyApp(ui, server)
