
#' GridStack Item
#'
#' @param ... Content of the item.
#' @param x,y (number) element position in column/row. Note: if one is missing this will autoPosition the item.
#' @param w,h (number) element size in column/row (default 1x1).
#' @param maxW,minW,maxH,minH element constraints in column/row (default none).
#' @param locked means another widget wouldn't be able to move it during dragging or resizing.
#'  The widget can still be dragged or resized by the user. You need to add noResize and noMove attributes to completely lock the widget.
#' @param noResize disable element resizing.
#' @param noMove disable element moving.
#' @param id Good for quick identification (for example in change event).
#' @param class_item,class_content,style_item,style_content CSS class or CSS styles to apply to the item container or the content.
#'
#' @return A `list()` with a `shiny.tag` class.
#' @export
#'
#' @importFrom htmltools tags
#'
#' @example examples/gs_item.R
gs_item <- function(...,
                    x = NULL,
                    y = NULL,
                    w = NULL,
                    h = NULL,
                    maxW = NULL,
                    minW = NULL,
                    maxH = NULL,
                    minH = NULL,
                    locked = NULL,
                    noResize = NULL,
                    noMove = NULL,
                    id = NULL,
                    class_item = NULL,
                    class_content = NULL,
                    style_item = NULL,
                    style_content = NULL) {
  tags$div(
    class = "grid-stack-item grid-stack-item-edit",
    `gs-x` = x,
    `gs-y` = y,
    `gs-w` = w,
    `gs-h` = h,
    `gs-max-w` = maxW,
    `gs-min-w` = minW,
    `gs-max-h` = maxH,
    `gs-min-h` = minH,
    `gs-locked` = locked,
    `gs-no-resize` = noResize,
    `gs-no-move` = noMove,
    `gs-id` = id,
    class = class_item,
    style = style_item,
    tags$div(
      class = "grid-stack-item-content",
      class = class_content,
      style = style_content,
      ...
    )
  )
}



#' Trash container
#'
#' Drag items from a GridStack to remove them
#'
#' @param id ID of the container.
#' @param label,icon Text and icon to be displayed inside the container.
#' @param color,bg Text and background colors.
#' @param fontSize Font size.
#' @param ... Other elements passed to tag object.
#' @param height,width Height and width for the container.
#'
#' @return An HTML tag that can be used in a UI.
#' @export
#'
#' @importFrom htmltools tags css validateCssUnit
#'
#' @example examples/shiny-trash.R
gs_trash <- function(id,
                     label = NULL,
                     icon = shiny::icon("trash", class = "fa-2x"),
                     color = "rgba(255, 0, 0, 0.9)",
                     bg = "rgba(255, 0, 0, 0.1)",
                     fontSize = "x-large",
                     ...,
                     height = "250px",
                     width = "100%") {
  tags$div(
    id = id,
    class = "gs-trash",
    style = css(
      background = bg,
      color = color,
      height = validateCssUnit(height),
      width = validateCssUnit(width),
      fontSize = fontSize
    ),
    tags$div(icon),
    tags$div(label),
    ...
  )
}



