
library(shiny)
library(bslib)
library(ggplot2)
library(gridstackr)

ui <- page_fluid(
  tags$h2("Two GridStack example"),
  fluidRow(
    column(
      width = 3,
      tags$b("List of charts to put in dashboard:"),
      # gridstackOutput("grid1")
      gridstack(
        column = 1,
        minRow = 1,
        cellHeight = "210px",
        options = list(
          acceptWidgets = TRUE,
          dragOut = TRUE
        ),
        elementId = "grid1"
      )
    ),
    column(
      width = 9,
      tags$b("Dashboard:"),
      gridstackOutput("grid2")
    )
  )
)

server <- function(input, output, session) {

  plot_list <- list(
    ggplot(mtcars) + geom_point(aes(mpg, disp)) + ggtitle("Plot 1"),
    ggplot(mtcars) + geom_boxplot(aes(gear, disp, group = gear)) + ggtitle("Plot 2"),
    ggplot(mtcars) + geom_smooth(aes(disp, qsec)) + ggtitle("Plot 3"),
    ggplot(mtcars) + geom_bar(aes(carb)) + ggtitle("Plot 4"),
    ggplot(mtcars) + geom_point(aes(hp, wt, colour = mpg)) + ggtitle("Plot 5")
  )

  # output$grid1 <- renderGridstack({
  #   gridstack(
  #     column = 4,
  #     minRow = 1,
  #     cellHeight = "210px",
  #     options = list(
  #       acceptWidgets = TRUE,
  #       dragOut = TRUE
  #     )#,
  #     # list_items = lapply(
  #     #   X = seq_along(plot_list),
  #     #   FUN = function(i) {
  #     #     gs_item(
  #     #       h = 2,
  #     #       id = paste0("plot_", i),
  #     #       renderPlot({
  #     #         plot_list[[i]]
  #     #       }, height = "100%", width = "100%")
  #     #     )
  #     #   }
  #     # )
  #   )
  # })

  observe({
    lapply(
      X = seq_along(plot_list),
      FUN = function(i) {
        gs_proxy_add("grid1",  plot_list[[i]], list(id = paste0("plot_", i), w = 4, h = 2))
      }
    )
  })

  output$grid2 <- renderGridstack({
    gridstack(
      minRow = 3,
      # cellHeight = "210px",
      options = list(
        acceptWidgets = TRUE,
        dragOut = TRUE
      )
    )
  })

}

if (interactive())
  shinyApp(ui, server)
