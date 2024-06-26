

#' @title Proxy for gridstack
#'
#' @description Allow to update a gridstack in Shiny application.
#'
#' @param shinyId single-element character vector indicating the output ID of the
#'   chart to modify (if invoked from a Shiny module, the namespace will be added
#'   automatically)
#' @param session the Shiny session object to which the chart belongs; usually the
#'   default value will suffice
#'
#' @export
#'
#' @importFrom shiny getDefaultReactiveDomain
#'
gridstack_proxy <- function(shinyId, session = shiny::getDefaultReactiveDomain()) {

  if (is.null(session)) {
    stop("gridstack_proxy must be called from the server function of a Shiny app")
  }

  if (!is.null(session$ns) && nzchar(session$ns(NULL)) && substring(shinyId, 1, nchar(session$ns(""))) != session$ns("")) {
    shinyId <- session$ns(shinyId)
  }

  structure(
    list(
      session = session,
      id = shinyId,
      x = list()
    ),
    class = "gridstack_proxy"
  )
}



#' Call a proxy method
#'
#' @param proxy  A `gridstack_proxy` `htmlwidget` object.
#' @param name Proxy method.
#' @param l List of arguments passed to method.
#'
#' @return A `gridstack_proxy` `htmlwidget` object.
#' @noRd
.gs_proxy <- function(proxy, name, l) {
  if (is.character(proxy) & length(proxy) == 1L)
    proxy <- gridstack_proxy(proxy)
  if (!"gridstack_proxy" %in% class(proxy))
    stop("This function must be used with a gridstack_proxy object", call. = FALSE)
  proxy$session$sendCustomMessage(
    type = sprintf("gridstackr-%s", name),
    message = list(id = proxy$id, data = l)
  )
  proxy
}



#' Add an item to a gridstack via proxy
#'
#' @param proxy Result of [gridstack_proxy()] or a character with the ID of the grid.
#' @param item The item to be added.
#' @param options List of options for the item, like in [gs_item()].
#'
#' @return A [gridstack_proxy()] object.
#' @export
#'
#' @importFrom shiny insertUI exprToFunction renderPlot
#'
#' @example examples/shiny-add.R
gs_proxy_add <- function(proxy, item, options = list()) {
  ID <- genId()
  if (is.null(options$content)) {
    options$content <- sprintf(
      '<div id="grid-stack-item-content-%s" style="width: 100%%; height: 100%%;"></div>',
      ID
    )
  }
  .gs_proxy(
    proxy = proxy,
    name = "add-widget",
    l = list(options = options)
  )
  if (inherits(item, "ggplot")) {
    gg_fun <- exprToFunction(item, parent.frame(), FALSE)
    item <- renderPlot({gg_fun()}, outputArgs = list(width = "100%", height = "100%"))
  }
  insertUI(
    selector = paste0("#grid-stack-item-content-", ID),
    ui = item
  )
}



#' Remove items from gridstack via proxy
#'
#' @param proxy Result of [gridstack_proxy()] or a character with the ID of the grid.
#' @param id Identifier of the item to be removed.
#'
#' @return A [gridstack_proxy()] object.
#' @export
#'
#' @name proxy-remove
#'
#' @example examples/shiny-remove.R
gs_proxy_remove_all <- function(proxy) {
  .gs_proxy(proxy, "remove-all", list())
}

#' @export
#'
#' @rdname proxy-remove
gs_proxy_remove_item <- function(proxy, id) {
  .gs_proxy(proxy, "remove-widget", list(id = id))
}



#' Proxy methods
#'
#' Call those functions from the server of an application to interact with a GridStack.
#'
#' @param proxy Result of [gridstack_proxy()] or a character with the ID of the grid.
#' @param layout re-layout grid items to reclaim any empty space. Options are:
#'   * 'list' keep the widget left->right order the same, even if that means leaving an empty slot if things don't fit
#'   * 'compact' might re-order items to fill any empty space.
#' @param doEnable Enables/disables widget moving or resizing.
#'
#' @return A [gridstack_proxy()] object.
#' @export
#'
#' @name proxy-methods
#'
#' @example examples/proxy-methods.R
gs_proxy_compact <- function(proxy, layout = c("list", "compact")) {
  .gs_proxy(proxy, "compact", list(layout = match.arg(layout)))
}

#' @export
#'
#' @rdname proxy-methods
gs_proxy_enable <- function(proxy) {
  .gs_proxy(proxy, "enable", list())
}

#' @export
#'
#' @rdname proxy-methods
gs_proxy_disable <- function(proxy) {
  .gs_proxy(proxy, "disable", list())
}

#' @export
#'
#' @rdname proxy-methods
gs_proxy_enable_move <- function(proxy, doEnable = TRUE) {
  .gs_proxy(proxy, "enable-move", list(doEnable = isTRUE(doEnable)))
}

#' @export
#'
#' @rdname proxy-methods
gs_proxy_enable_resize <- function(proxy, doEnable = TRUE) {
  .gs_proxy(proxy, "enable-resize", list(doEnable = isTRUE(doEnable)))
}

