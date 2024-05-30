
#' Create a patchwork design
#'
#' @param grid_layout Layout of the GridStack retrieved via `input$<outputId>_layout`.
#'
#' @return An expression that can be evaluated to create a design usable in {patchwork}.
#' @export
#'
#' @importFrom rlang expr %||%
#'
#' @example examples/patchwork-design.R
create_design <- function(grid_layout) {
  if (is.null(grid_layout$children))
    stop("grid_layout must be the value stored in `input$<outputId>_layout`")
  design <- lapply(
    X = grid_layout$children,
    FUN = function(x) {
      t <- x$y + 1
      l <- x$x + 1
      b <- x$y + x$h %||% 1
      r <- x$x + x$w %||% 1
      expr(area(!!t, !!l, !!b, !!r))
    }
  )
  expr(c(!!!design))
}

