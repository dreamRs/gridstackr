
library(shiny)
library(bslib)
library(ggplot2)
library(gridstackr)
library(patchwork)

ui <- page_fluid(
  tags$h2("Create {patchwork} design"),
  fluidRow(
    column(
      width = 6,
      tags$b("Create your design:"),
      gridstackOutput("grid")
    ),
    column(
      width = 6,
      tags$b("Result:"),
      plotOutput("design")
    )
  )
)

server <- function(input, output, session) {

  output$grid <- renderGridstack({
    gridstack(
      resize_handles = "se,e,s",
      gs_item(
        plotOutput("plot1", height = "100%")
      ),
      gs_item(
        plotOutput("plot2", height = "100%")
      ),
      gs_item(
        plotOutput("plot3", height = "100%")
      ),
      gs_item(
        plotOutput("plot4", height = "100%")
      )
    )
  })

  output$plot1 <- renderPlot({
    ggplot(mtcars) + geom_point(aes(mpg, disp))
  })
  outputOptions(output, "plot1", suspendWhenHidden = TRUE)
  output$plot2 <- renderPlot({
    ggplot(mtcars) + geom_boxplot(aes(gear, disp, group = gear))
  })
  output$plot3 <- renderPlot({
    ggplot(mtcars) + geom_smooth(aes(disp, qsec))
  })
  output$plot4 <- renderPlot({
    ggplot(mtcars) + geom_bar(aes(carb))
  })

  output$design <- renderPlot({
    req(input$grid_layout)
    mydesign <- create_design(input$grid_layout)
    plot(eval(mydesign))
  })

}

if (interactive())
  shinyApp(ui, server)
