% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/gridstack.R
\name{gridstack-shiny}
\alias{gridstack-shiny}
\alias{gridstackOutput}
\alias{renderGridstack}
\title{Shiny bindings for gridstack}
\usage{
gridstackOutput(outputId, width = "100\%", height = "400px")

renderGridstack(expr, env = parent.frame(), quoted = FALSE)
}
\arguments{
\item{outputId}{output variable to read from}

\item{width, height}{Must be a valid CSS unit (like \code{"100\%"},
\code{"400px"}, \code{"auto"}) or a number, which will be coerced to a
string and have \code{"px"} appended.}

\item{expr}{An expression that generates an HTML widget (or a
\href{https://rstudio.github.io/promises/}{promise} of an HTML widget).}

\item{env}{The environment in which to evaluate \code{expr}.}

\item{quoted}{Is \code{expr} a quoted expression (with \code{quote()})? This
is useful if you want to save an expression in a variable.}
}
\value{
\code{gridstackOutput} returns a UI definition, \code{renderGridstack} is used to create associated output in shiny server.
}
\description{
Output and render functions for using gridstack within Shiny
applications and interactive Rmd documents.
}
\note{
The GridStack layout can be retrieved via the special shiny input \verb{input$<outputId>_layout}.
}
\examples{

library(shiny)
library(bslib)
library(ggplot2)
library(gridstackr)

ui <- page_fluid(
  tags$h2("GridStack example"),
  gridstack(
    margin = "10px",
    cellHeight = "140px",
    float = TRUE,
    gs_item(value_box(
      title = "Customer lifetime value",
      value = "$5,000",
      showcase = icon("bank"),
      theme = "text-success",
      class = "mb-0"
    ), w = 6, h = 1),
    gs_item(value_box(
      title = "Customer lifetime value",
      value = "$5,000",
      showcase = icon("bank"),
      theme = value_box_theme(bg = "#e6f2fd", fg = "#0B538E"),
      class = "border mb-0"
    ), w = 6, h = 1),
    gs_item(
      plotOutput("plot1", height = "100\%"),
      w = 4, h = 2, class_content = "bg-white p-2 border rounded-4"
    ),
    gs_item(
      plotOutput("plot2", height = "100\%"),
      w = 4, h = 2, class_content = "bg-white p-2 border rounded-4"
    ),
    gs_item(
      plotOutput("plot3", height = "100\%"),
      w = 4, h = 2, class_content = "bg-white p-2 border rounded-4"
    ),
    gs_item(
      plotOutput("plot4", height = "100\%"),
      w = 12, h = 2, class_content = "bg-white p-2 border rounded-4"
    )
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

if (interactive())
  shinyApp(ui, server)

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
      minRow = 2,
      margin = "0.2rem",
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
}
