library(gridstackr)

gridstack(
  gs_item("1", w = 4, style = "border-radius: 8px; border: 1px solid red"),
  gs_item("2", w = 4, style = "border-radius: 8px; border: 1px solid red"),
  gs_item("3", w = 4, style = "border-radius: 8px; border: 1px solid red"),
  gs_item("4", w = 12, style = "border-radius: 8px; border: 1px solid red")
)

gridstack(
  options = list(minRow = 2, margin = "0.2rem"),
  gs_item("1", w = 4, h = 2, style = "border-radius: 8px; border: 1px solid red"),
  gs_item("2", w = 5, style = "border-radius: 8px; border: 1px solid red"),
  gs_item("3", w = 5, x = 4, y = 2, style = "border-radius: 8px; border: 1px solid red"),
  gs_item("4", h = 2, w = 3, style = "border-radius: 8px; border: 1px solid red"),
  gs_item("5", w = 6, x = 0, y = 3, style = "border-radius: 8px; border: 1px solid red"),
  gs_item("6", w = 6, x = 6, y = 3, style = "border-radius: 8px; border: 1px solid red")
)
