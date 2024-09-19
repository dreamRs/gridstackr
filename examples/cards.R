
library(shiny)
library(bslib)
library(ggplot2)
library(gridstackr)


full_screen_toggle <- function(id_controls) {
  tooltip(
    tags$button(
      class = "bslib-full-screen-enter",
      class = "badge rounded-pill",
      "aria-expanded" = "false",
      "aria-controls" = id_controls,
      "aria-label" = "Expand card",
      full_screen_toggle_icon()
    ),
    "Expand"
  )
}

card_init_js <- function() {
  tags$script(
    `data-bslib-card-init` = NA,
    HTML("bslib.Card.initializeAllCards();")
  )
}

full_screen_toggle_icon <- function() {
  # https://www.visiwig.com/icons/
  # https://www.visiwig.com/icons-license/
  HTML('<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" style="height:1em;width:1em;fill:currentColor;" aria-hidden="true" role="img"><path d="M20 5C20 4.4 19.6 4 19 4H13C12.4 4 12 3.6 12 3C12 2.4 12.4 2 13 2H21C21.6 2 22 2.4 22 3V11C22 11.6 21.6 12 21 12C20.4 12 20 11.6 20 11V5ZM4 19C4 19.6 4.4 20 5 20H11C11.6 20 12 20.4 12 21C12 21.6 11.6 22 11 22H3C2.4 22 2 21.6 2 21V13C2 12.4 2.4 12 3 12C3.6 12 4 12.4 4 13V19Z"/></svg>')
}

# jcheng 2022-06-06: Removing for now; list items have more features than I'm
# ready to design an API for right now
#
# #' @rdname card_body
# #' @export
# card_list <- function(...) {
#   res <- tags$ul(class = "list-group list-group-flush", ...)
#   as.card_item(res)
# }
#
# #' @export
# card_list_item <- function(...) {
#   tags$li(class = "list-group-item", ...)
# }

component_dependencies <- function() {
  list(
    component_dependency_js(),
    bs_dependency_defer(component_dependency_sass)
  )
}

get_package_version <- function(pkg) {
  # `utils::packageVersion()` can be slow, so first try the fast path of
  # checking if the package is already loaded.
  ns <- .getNamespace(pkg)
  if (is.null(ns)) {
    utils::packageVersion(pkg)
  } else {
    as.package_version(ns$.__NAMESPACE__.$spec[["version"]])
  }
}

component_dependency_js <- function() {
  minified <- TRUE #get_shiny_devmode_option("shiny.minified", default = TRUE)

  htmltools::htmlDependency(
    name = "bslib-component-js",
    version = get_package_version("bslib"),
    package = "bslib",
    src = "components/dist",
    script = list(
      list(src = paste0("components", if (minified) ".min", ".js")),
      list(
        src = paste0("web-components", if (minified) ".min", ".js"),
        type = "module"
      )
    )
  )
}

# Pre-compiled component styles
component_dependency_css <- function() {
  htmlDependency(
    name = "bslib-component-css",
    version = get_package_version("bslib"),
    package = "bslib",
    src = "components/dist",
    stylesheet = "components.css"
  )
}

# Run-time (Sass) component styles
component_dependency_sass <- function(theme) {
  precompiled <- isTRUE(get_precompiled_option())
  default_theme <- !is_bs_theme(theme) || identical(theme, bs_theme())
  if (precompiled && default_theme) {
    component_dependency_css()
  } else {
    component_dependency_sass_(theme)
  }
}

component_dependency_sass_files <- function() {
  scss_dir <- path_inst("components", "scss")
  scss_files <- c(
    file.path(scss_dir, "mixins", "_mixins.scss"),
    dir(scss_dir, pattern = "\\.scss$", full.names = TRUE)
  )

  lapply(scss_files, sass_file)
}

component_dependency_sass_ <- function(theme) {
  # Although rare, it's possible for bs_dependency_defer() to pass
  # along a NULL theme (e.g., renderTags(accordion())), so fallback
  # to the default theme if need be
  theme <- theme %||% bs_theme()

  if (theme_version(theme) < 5) {
    abort(c(
      "bslib components require Bootstrap 5 or higher.",
      "i" = "Do you need to specify a different `version` in `bs_theme()`?"
    ))
  }

  bs_dependency(
    input = component_dependency_sass_files(),
    theme = theme,
    name = "bslib-component-css",
    version = get_package_version("bslib"),
    cache_key_extra = get_package_version("bslib"),
    .sass_args = list(options = sass_options(output_style = "compressed"))
  )
}


web_component <- function(tagName, ...) {
  deps <- component_dependencies()
  args <- c(deps, rlang::list2(...))
  htmltools::tag(tagName, args)
}

ui <- bslib::page_fluid(
  tags$h2("GridStack card example"),
  theme = bslib::bs_theme(preset = "shiny"),
  shiny::tags$head(
    shiny::tags$style("
      .card-handle {
        cursor: move;
        min-height: 25px;
      }
      .card-handle:hover {
        background-color: rgba(0,0,0,0.1);
      }
      .card {
        text-align: left;
      }
      .resize-vertical {
        resize: vertical;
      }
      .resize-horizontal {
        resize: horizontal;
      }
      .resize-both {
        resize: both;
      }
    ")
  ),
  gridstack(
    margin = "10px",
    cellHeight = "140px",
    float = FALSE,
    column = 6,
    options = list(handle = ".card-handle"),
    gs_item(
      plotOutput("plot1", height = "100%"),
      w = 6, h = 2, class_content = "bg-white p-2 border rounded-4"
    ),
    gs_item(
      plotOutput("plot2", height = "100%"),
      w = 3, h = 2, class_content = "bg-white p-2 border rounded-4"
    ),
    gs_item(
      plotOutput("plot3", height = "100%"),
      w = 3, h = 2, class_content = "bg-white p-2 border rounded-4"
    ),
    gs_item(
      plotOutput("plot4", height = "100%"),
      w = 2, h = 2, class_content = "bg-white p-2 border rounded-4"
    ),
    gs_item(
      height = "100%",
      class = "card bslib-card bslib-mb-spacing",
      "data-bslib-card-init" = NA,
      "data-full-screen" = "false",
      bslib::card_header(
        shiny::icon("up-down-left-right", class = "fa-solid ms-auto card-handle", lib = "font-awesome"),
      ),
      full_screen_toggle("#test"),
      bslib::card_body(
        id = "test",
        plotOutput("plot4"),
      ),
      card_init_js(),
      component_dependencies(),
      w = 4, h = 2
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
