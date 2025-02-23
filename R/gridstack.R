#' Gridstack HTMLwidget
#'
#' Mobile-friendly modern Typescript library for dashboard layout and creation. Making a drag-and-drop, multi-column responsive dashboard has never been easier.
#'
#' @param ... Items created with [gs_item()] to be placed in the grid.
#' @param alwaysShowResizeHandle Always show or not the resizing handles.
#' @param animate Turns animation on to smooth transitions.
#' @param cellHeight One cell height. Can be:
#'   * an integer (px)
#'   * a string (ex: '100px', '10em', '10rem', '10cm'). Note: % doesn't right
#'   * 0, in which case the library will not generate styles for rows. Everything must be defined in your own CSS files.
#'   * auto - height will be calculated for square cells (width / column) and updated live as you resize the window
#'   * initial - similar to 'auto' (start at square cells) but stay that size during window resizing.
#' @param column Number of columns, default to 12.
#' @param float Enable floating widgets (default: false).
#' @param disableDrag Disallows dragging of widgets (default: false).
#' @param disableResize Disallows resizing of widgets (default: false).
#' @param margin Gap size around grid item and content (default: 10). Can be:
#'   * an integer (px)
#'   * a string (ex: '2em', '20px', '2rem')
#' @param maxRow Maximum rows amount. Default is 0 which means no max.
#' @param minRow Minimum rows amount which is handy to prevent grid from collapsing when empty.
#'  Default is 0. You can also do this with min-height CSS attribute on the grid div in pixels, which will round to the closest row.
#' @param removable If true widgets could be removed by dragging outside of the grid.
#'  It could also be a selector string, in this case widgets will be removed by dropping them there (default: false).
#' @param trash_id ID of the trash container, see [gs_trash()], if used then `removable` is ignored.
#' @param resize_handles Cn be any combo of n,ne,e,se,s,sw,w,nw or all.
#' @param class Additional class on top of '.grid-stack' to differentiate this instance.
#' @param options List of options for the grid.
#' @param bg Background color.
#' @param list_items A `list` of items created with [gs_item()] to be placed in the grid. An alternative to `...` to specify items.
#' @inheritParams htmlwidgets::createWidget
#'
#' @return A gridstack HTMLwidget object.
#'
#' @importFrom htmlwidgets createWidget sizingPolicy
#' @importFrom htmltools renderTags
#'
#' @export
#'
#' @example examples/gridstack.R
gridstack <- function(...,
                      alwaysShowResizeHandle = FALSE,
                      animate = TRUE,
                      cellHeight = "auto",
                      column = 12,
                      float = FALSE,
                      disableDrag = FALSE,
                      disableResize = FALSE,
                      margin = 10,
                      maxRow = 0,
                      minRow = 0,
                      removable = FALSE,
                      trash_id = NULL,
                      resize_handles = "se",
                      class = NULL,
                      options = list(),
                      bg = "#e5e7eb",
                      list_items = NULL,
                      width = NULL,
                      height = NULL,
                      elementId = NULL) {

  items <- c(list(...), list_items)
  rendered_items <- renderTags(x = items)

  x <- list(
    html = rendered_items$html,
    options = c(dropNulls(list(
      alwaysShowResizeHandle = alwaysShowResizeHandle,
      animate  = animate,
      cellHeight = cellHeight,
      column = column,
      class = class,
      float = float,
      disableDrag = disableDrag,
      disableResize = disableResize,
      margin = margin,
      maxRow = maxRow,
      minRow = minRow,
      removable = if (!is.null(trash_id)) paste0("#", trash_id) else removable,
      resizable = list(handles = resize_handles)
    )), options),
    bg = bg
  )

  htmlwidgets::createWidget(
    name = "gridstack",
    x = x,
    dependencies = rendered_items$dependencies,
    width = width,
    height = height,
    package = "gridstackr",
    elementId = elementId,
    sizingPolicy = htmlwidgets::sizingPolicy(
      defaultWidth = "100%",
      viewer.defaultHeight = "100%",
      viewer.defaultWidth = "100%",
      viewer.fill = FALSE,
      knitr.figure = FALSE,
      viewer.suppress = FALSE,
      browser.external = TRUE,
      browser.fill = FALSE,
      padding = 5
    )
  )
}





#' @title Shiny bindings for gridstack
#'
#' @description
#' Output and render functions for using gridstack within Shiny
#' applications and interactive Rmd documents.
#'
#' @inheritParams htmlwidgets::shinyWidgetOutput
#' @inheritParams htmlwidgets::shinyRenderWidget
#'
#' @return `gridstackOutput` returns a UI definition, `renderGridstack` is used to create associated output in shiny server.
#'
#' @note
#' The GridStack layout can be retrieved via the special shiny input `input$<outputId>_layout`.
#'
#' @name gridstack-shiny
#' @importFrom htmlwidgets shinyWidgetOutput shinyRenderWidget
#' @export
#'
#' @example examples/shiny.R
#'
#' @example examples/shiny-input.R
gridstackOutput <- function(outputId, width = "100%", height = "400px") {
  shinyWidgetOutput(outputId, "gridstack", width, height, package = "gridstackr")
}

#' @rdname gridstack-shiny
#' @export
renderGridstack <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  shinyRenderWidget(expr, gridstackOutput, env, quoted = TRUE)
}
