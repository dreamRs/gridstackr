library(data.table)
library(bslib)
library(gridstackr)
library(shiny)


my_pkgs <- c("shinyWidgets", "esquisse", "datamods", "shinylogs", "shinybusy", "fresh", "phosphoricons", "toastui", "apexcharter", "billboarder", "gfonts")

pkgs <- tools::CRAN_package_db()
setDT(pkgs)

pkgs <- pkgs[Package %in% my_pkgs]


card_pkg <- function(.list) {
  card(
    card_header(.list$Package, class = "bg-primary fw-bold"),
    card_body(
      tags$div(.list$Title),
      tags$div(.list$Description)
    ),
    fill = FALSE,
    height = "100%",
    class = "mb-0"
  )
}

item_pkg <- function(pkg) {
  gs_item(card_pkg(pkg), w = 3, id = pkg$Package, sizeToContent = TRUE)
}
item_pkg_all <- function(pkgs) {
  lapply(
    X = apply(pkgs, 1, as.list),
    FUN = item_pkg
  )
}

add_pkg <- function(pkg) {
  gs_proxy_add("mygrid",  card_pkg(pkg), options = list(w = 3, id = pkg$Package))
}
add_pkg_all <- function(pkgs) {
  lapply(
    X = apply(pkgs, 1, as.list),
    FUN = add_pkg
  )
}



ui <- page_fluid(
  tags$h2("Filter GridStack example"),
  shinyWidgets::searchInput(
    inputId = "search",
    label = "Search grid:",
    btnSearch = icon("magnifying-glass"),
    btnReset = icon("xmark")
  ),
  gridstackOutput("mygrid"),
  verbatimTextOutput("res")
)

server <- function(input, output, session) {

  output$mygrid <- renderGridstack({
    gridstack(
      minRow = 2,
      cellHeight = "200px",
      disableResize = TRUE,
      disableDrag = TRUE,
      list_items = item_pkg_all(pkgs)
    )
  })

  output$res <- renderPrint({
    data.table::rbindlist(input$mygrid_layout$children, fill = TRUE)
  })

  ### Method 1: Always remove items then put back items corresponding to search
  # observeEvent(input$search, {
  #   gs_proxy_remove_all("mygrid")
  #   if (!isTruthy(input$search)) {
  #     add_pkg_all(pkgs)
  #   } else {
  #     pkgs_search <- pkgs[tolower(Description) %like% tolower(input$search)]
  #     add_pkg_all(pkgs_search)
  #   }
  # }, ignoreNULL = FALSE, ignoreInit = TRUE)

  ### Method 2 : add or remove according to items in the frid
  observeEvent(input$search, {
    items_grid <- data.table::rbindlist(input$mygrid_layout$children, fill = TRUE)
    pkgs_search <- pkgs[tolower(Description) %like% tolower(input$search)]
    for (pkg in my_pkgs) {
      if (pkg %in% pkgs_search$Package) {
        if (pkg %in% items_grid$id) {
          # already in grid
        } else {
          add_pkg(pkgs_search[Package == pkg])
        }
      } else {
        if (pkg %in% items_grid$id) {
          gs_proxy_remove_item("mygrid", pkg)
        } else {
          # not in grid
        }
      }
    }

  }, ignoreNULL = FALSE, ignoreInit = TRUE)

}

if (interactive())
  shinyApp(ui, server)
