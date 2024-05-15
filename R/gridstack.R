#' Gridstack HTMLwidget
#'
#' Mobile-friendly modern Typescript library for dashboard layout and creation. Making a drag-and-drop, multi-column responsive dashboard has never been easier.
#'
#' @import htmlwidgets
#'
#' @export
gridstack <- function(..., options = list(), width = NULL, height = NULL, elementId = NULL) {

  items <- list(...)
  rendered_items <- renderTags(x = items)

  x <- list(
    html = rendered_items$html,
    options = options
  )

  htmlwidgets::createWidget(
    name = "gridstack",
    x = x,
    dependencies = rendered_items$dependencies,
    width = width,
    height = height,
    package = "gridstackr",
    elementId = elementId
  )
}

#' #' @importFrom htmltools tags
#' gridstack_html <- function(id, style, class, ...) {
#'   tags$div(
#'     id = id,
#'     class = class,
#'     class = "grid-stack",
#'     style = style,
#'     ...
#'   )
#' }

#' Shiny bindings for gridstack
#'
#' Output and render functions for using gridstack within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a gridstack
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name gridstack-shiny
#'
#' @export
gridstackOutput <- function(outputId, width = "100%", height = "400px"){
  htmlwidgets::shinyWidgetOutput(outputId, "gridstack", width, height, package = "gridstackr")
}

#' @rdname gridstack-shiny
#' @export
renderGridstack <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, gridstackOutput, env, quoted = TRUE)
}
