
library(gridstackr)

gridstack(
  gs_item("1", w = 4, h = 2),
  gs_item("Locked (can't be moved when other are moved)", w = 5, locked = TRUE),
  gs_item("No move", w = 5, x = 4, y = 2, noMove = TRUE),
  gs_item("No resize", h = 2, w = 3, noResize = TRUE),
  gs_item("Max width = 8", w = 6, x = 0, y = 3, maxW = 8),
  gs_item("Max height = 2", w = 6, x = 6, y = 3, maxH = 2)
)

