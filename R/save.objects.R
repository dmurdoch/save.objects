#' RStudio Addin to Save Object from Environment to File
#' @name save.objects
#' @export
#' @import shiny miniUI
#' @examples
#' \dontrun{saveobjects()}

save.objects <- function() {

  # ui
  ui <- miniPage(
    miniTitleBar('Select Objects to Save', right=miniTitleBarButton('done', 'Save', primary = TRUE)),
    miniContentPanel(
      textInput('filename', label = 'Save as:', value = '.RData'),
      DT::dataTableOutput('tbl')
    )
  )

  # server
  server <- function(input, output, session) {

    objects <- data.frame(Environment = ls(.GlobalEnv))

    output$tbl = DT::renderDataTable(
      objects, options = list(lengthChange = FALSE, paging=FALSE, searching=FALSE)
    )

    observeEvent(input$done, {
      names <- as.character(objects[input$tbl_rows_selected, 1])
      filename <- input$filename
      stopApp( save(list = names, file = filename)  )
    })

  }

  # run app
  runGadget(ui, server, viewer = dialogViewer("Save Objects"))
}
