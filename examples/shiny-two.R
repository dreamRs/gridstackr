
library(shiny)
library(bslib)
library(ggplot2)
library(gridstackr)

ui <- page_fluid(
  tags$h2("Two GridStack example"),
  fluidRow(
    column(
      width = 3,
      tags$b("List of items to put in dashboard:"),
      gridstackOutput("grid1")
    ),
    column(
      width = 9,
      tags$b("Dashboard:"),
      gridstackOutput("grid2")
    )
  )
)

server <- function(input, output, session) {

  output$grid1 <- renderGridstack({
    gridstack(
      margin = "10px",
      cellHeight = "140px",
      column = 3,
      options = list(
        acceptWidgets = TRUE,
        dragOut = TRUE
      ),
      gs_item(
        w = 3,
        value_box(
          title = "Customer lifetime value",
          value = "$5,000",
          showcase = icon("bank"),
          theme = "text-success",
          class = "mb-0"
        )
      ),
      gs_item(
        w = 3,
        value_box(
          title = "Customer lifetime value",
          value = "$5,000",
          showcase = icon("bank"),
          theme = value_box_theme(bg = "#e6f2fd", fg = "#0B538E"),
          class = "border mb-0"
        )
      ),
      gs_item(
        w = 3,
        plotOutput("plot1", height = "100%"),
        class_content = "bg-white p-2 border rounded-4"
      ),
      gs_item(
        w = 3,
        plotOutput("plot2", height = "100%"),
        class_content = "bg-white p-2 border rounded-4"
      ),
      gs_item(
        w = 3,
        plotOutput("plot3", height = "100%"),
        class_content = "bg-white p-2 border rounded-4"
      ),
      gs_item(
        w = 3,
        plotOutput("plot4", height = "100%"),
        class_content = "bg-white p-2 border rounded-4"
      )
    )
  })

  output$grid2 <- renderGridstack({
    gridstack(
      minRow = 3,
      column = 6,
      cellHeight = "140px",
      options = list(
        acceptWidgets = TRUE,
        dragOut = TRUE
      )
    )
  })

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

if (interactive())
  shinyApp(ui, server)
