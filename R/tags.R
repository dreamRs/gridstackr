
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
#'
#' @return A `list()` with a `shiny.tag` class.
#' @export
#'
#' @importFrom htmltools tags
#'
#' @examples
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
                    noMove = NULL) {
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
    tags$div(
      class = "grid-stack-item-content grid-stack-item-content-edit",
      ...
    )
  )
}
