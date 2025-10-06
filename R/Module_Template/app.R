# Module Template for Shiny Apps

# Use box to import only the functions you need from each package
box::use(
  bslib[layout_column_wrap, card, card_title, card_body],
  markdown[markdownToHTML]
)

# --------------------------------
# This file demonstrates how to create a reusable Shiny module.
#
# How to use this template:
# 1. Copy this file to a new folder for your app/module.
# 2. Rename the UI and server functions (e.g., my_module_ui/server) to match your module's name.
# 3. Replace the UI and server logic with your own app's functionality.
# 4. The module can be used in a main app by calling <your_module>_ui(id) and <your_module>_server(id).
# 5. The code viewer below will always show the current code of this file in the UI for easy reference.
#
# For more info on Shiny modules, see: https://shiny.rstudio.com/articles/modules.html
#
# Best practices:
# - Always use the 'id' argument and NS() for all input/output IDs.
# - Keep UI and server logic inside their respective functions.
# - Avoid using global variables for user input/output.
# - Document your module's purpose and usage at the top of the file.


# -----------------
# Module definition
# -----------------
my_module_ui <- function(id) {
  ns <- NS(id)
  layout_column_wrap(
    width = 1/2,
    card(
      card_title("README.md"),
      card_body(
        htmlOutput(
          ns("readme"), 
          style = "overflow-y:auto; max-height:80vh; border:1px solid #ccc; padding:8px; background:#fafbfc;"
        )
      )
    ),
    card(
      card_title("Module Apps Source Code"),
      verbatimTextOutput(ns("code"), placeholder = TRUE)
    )
  )
}

my_module_server <- function(id) {
  moduleServer(id, function(input, output, session) {
      # Show the code of this app in the UI
      output$code <- renderText({
        code_path <- normalizePath("R/Module_Template/app.R", mustWork = FALSE)
        if (file.exists(code_path)) {
          paste(readLines(code_path, warn = FALSE), collapse = "\n")
        } else {
          "Source code not found."
        }
      })

      # Show the README.md rendered as HTML
      output$readme <- renderUI({
        readme_path <- normalizePath("README.md", mustWork = FALSE)
        if (file.exists(readme_path)) {
          # Use markdown package to render HTML
          HTML(markdownToHTML(readme_path, fragment.only = TRUE))
        } else {
          HTML("<em>README.md not found.</em>")
        }
      })
  })
}

# -----------------
# Standalone mode
# -----------------
# This section allows you to run and test this module independently, without needing a main app.
#
# How it works:
# - When you open this file and click 'Run App' in RStudio, this section will launch the module as a standalone Shiny app.
# - This is useful for developing and debugging your module in isolation.
# - When your module is used inside a larger app, this section is ignored.
#
# You do not need to modify this section unless you want to customize the standalone test UI.
if (sys.nframe() == 0) {
  standalone_ui <- fluidPage(
    titlePanel("Standalone Module Example"),
    my_module_ui("m1")
  )
  standalone_server <- function(input, output, session) {
    my_module_server("m1")
  }
  shinyApp(standalone_ui, standalone_server)
}