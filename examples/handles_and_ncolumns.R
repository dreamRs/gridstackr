# This demonstrates how to use fewer than 12 columns in gridstackr,
# some basic card styling, and how to use grab handles for position
# control instead of making the whole div grabbable..

library(shiny)
library(bslib)
library(ggplot2)
library(gridstackr)


full_screen_toggle <- function(id_controls) {
  tooltip(
    tags$button(
      class = "bslib-full-screen-enter",
      "aria-expanded" = "false",
      "aria-controls" = id_controls,
      "aria-label" = "Expand card",
      full_screen_toggle_icon()
    ),
    "Expand"
  )
}

window_move_handle <- function() {
  htmltools::tags$div(
    class = "card-handle card-handle-button",
    shiny::icon("up-down-left-right", class = "fa-solid", lib = "font-awesome")
  )
}

ui <- bslib::page_fluid(
  tags$h2("GridStack card example"),
  theme = bslib::bs_theme(preset = "shiny"),
  shiny::tags$head(
    shiny::tags$style("
      .card-handle {
        cursor: move;
      }
      .card-handle:hover {
        background-color: rgba(0,0,0,0.1);
      }
      .card-handle-button {
        position: absolute;
        right: 25px; /* sets it in top right of parent container */
        top: 25px;
        height: 50px;
        width: 50px;
        border-radius: 50px; /* gives it the circular button shape */
        text-align: center; /* puts the icon in the middle horizontally */
      }
      .card-handle-button i { /* Applies this style to any <i> tags within the container */
        position: relative;
        top: calc(50% - 12.5px);
      }

      .card-handle-header-button {
        float: right;
        height: 25px;
        width: 25px;
        border-radius: 50px;
        text-align: center;
      }

      /* Applies this style to any <i> tags within the container.
      In this case it isn't super necessary because the icon is nearly the same
      size as the circle. */
      .card-handle-header-button i {
        position: relative;
        top: calc(50% - 12.5px);
      }
    ")
  ),
  gridstack(
    margin = "10px",
    cellHeight = "140px",
    float = FALSE, # Set to true if you want to be able to keep spaces in the middle of the page
    column = 6,
    options = list(handle = ".card-handle"), # Necessary to set the grab handle element
    gs_item( # If a gard doesn't have an element with class .card-handle the whole thing will be grabbable
      class = "card",
      shiny::plotOutput("plot1", height = "100%"),
      w = 3,
      h = 2
    ),
    gs_item(
      class = "card",
      bslib::card_body(paste(
        "Notice that we only have 6 columns because we set column=6.",
        "This gives it a blockier feel, and can make things align and resize a",
        "bit more cleanly depending on what you're after."
      )),
      w = 3,
      h = 2
    ),
    gs_item( # Setting an element with class .card-handle means that only that element will be grabbable
      class = "card",
      window_move_handle(),
      shiny::plotOutput("plot2", height = "100%"),
      class_content = "p-2", # Gives it a bit of padding on the inside. CF plot 1
      w = 6,
      h = 2
    ),
    gs_item(
      class = "card",
      bslib::card_header(
        "Plot 3",
        htmltools::tags$div(
          class = "card-handle-header-button card-handle",
          shiny::icon("up-down-left-right", class = "fa-solid", lib = "font-awesome")
        )
      ),
      bslib::card_body( # You could use bslib instead of class_content
        id = "test",
        plotOutput("plot3")
      ),
      w = 4,
      h = 2
    ),
    gs_item( # You could also just set the whole header to be grabbable.
      class = "card",
      bslib::card_header(
        class = "card-handle",
        "Plot 4"
      ),
      shiny::plotOutput("plot4", height = "100%"),
      w = 2,
      h = 2
    )
  )
)

server <- function(input, output, session) {

  output$plot1 <- renderPlot({
    ggplot(mtcars) + geom_boxplot(aes(gear, disp, group = gear)) + ggtitle("Plot 1")
  })
  output$plot2 <- renderPlot({
    ggplot(mtcars) + geom_point(aes(mpg, disp)) + ggtitle("Plot 2")
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
