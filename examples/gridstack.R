library(gridstackr)

gridstack(
  gs_item("1", w = 4, class_content = "gs-item-example"),
  gs_item("2", w = 4, class_content = "gs-item-example"),
  gs_item("3", w = 4, class_content = "gs-item-example"),
  gs_item("4", w = 12, class_content = "gs-item-example")
)

gridstack(
  options = list(minRow = 2, margin = "0.2rem"),
  gs_item("1", w = 4, h = 2, class_content = "gs-item-example"),
  gs_item("2", w = 5, class_content = "gs-item-example"),
  gs_item("3", w = 5, x = 4, y = 2, class_content = "gs-item-example"),
  gs_item("4", h = 2, w = 3, class_content = "gs-item-example"),
  gs_item("5", w = 6, x = 0, y = 3, class_content = "gs-item-example"),
  gs_item("6", w = 6, x = 6, y = 3, class_content = "gs-item-example")
)
