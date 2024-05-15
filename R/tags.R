

gs_container <- function(..., gridId = NULL) {
  if (is.null(gridId))
    gridId <- genId()
  tag <- tags$div(
    id = gridId,
    class = "grid-stack",
    ...,
    gridstack(gridId = gridId, height = 0, width = 0)
  )
  browsable(tag)
}

gs_item <- function(...,
                    x = NULL,
                    y = NULL,
                    w = NULL,
                    h = NULL) {
  tags$div(
    class = "grid-stack-item",
    `gs-x` = x,
    `gs-y` = y,
    `gs-w` = w,
    `gs-h` = h,
    tags$div(
      class = "grid-stack-item-content",
      ...
    )
  )
}
