# Developer Guide

Complete guide for adding new modules to the Small Shiny Apps Platform.

---

## Development Setup

### Prerequisites
- R (>= 4.0)
- RStudio (recommended)
- Git

### Initial Setup

```bash
# Clone the repository
git clone https://github.com/SumedhSankhe/Small-Shiny-Apps-Platform.git
cd Small-Shiny-Apps-Platform

# Restore R package dependencies
Rscript -e "renv::restore()"

# Run the app
Rscript -e "shiny::runApp('app_launcher.R')"
```

---

## Adding a New Module

### Quick Start (5 minutes)

1. **Copy the template**:
   ```bash
   mkdir R/My_New_Tool
   cp R/Module_Template/app.R R/My_New_Tool/app.R
   ```

2. **Edit `R/My_New_Tool/app.R`**:
   ```r
   # Rename functions to match your module
   my_tool_ui <- function(id) {
     ns <- NS(id)
     # Your UI code here
   }

   my_tool_server <- function(id) {
     moduleServer(id, function(input, output, session) {
       # Your server logic here
     })
   }
   ```

3. **Register in `modules_list.json`**:
   ```json
   {
     "id": "my_new_tool",
     "label": "My New Tool",
     "source": "R/My_New_Tool/app.R",
     "ui": "my_tool_ui",
     "server": "my_tool_server",
     "preload": false,
     "cache": false
   }
   ```

4. **Test standalone** (optional):
   - Open `R/My_New_Tool/app.R` in RStudio
   - Click "Run App" to test in isolation

5. **Launch the platform** and select your tool from the dropdown

---

## Module Registry Reference

### `modules_list.json` Schema

Each module requires these properties:

```json
{
  "id": "unique_module_id",         // Used for internal routing (required)
  "label": "Display Name",          // Shown in dropdown menu (required)
  "source": "R/Module/app.R",       // Path to module file (required)
  "ui": "module_ui_function",       // Name of UI function (required)
  "server": "module_server_function", // Name of server function (required)
  "preload": false,                 // Load at startup? (optional, default: false)
  "cache": false                    // Cache module environment? (optional, default: false)
}
```

#### Property Details

- **`id`**: Must be unique, lowercase, use underscores for spaces
- **`label`**: User-friendly name shown in the app
- **`source`**: Relative path from project root to the module's `app.R`
- **`ui`**: Exact name of the UI function defined in `app.R`
- **`server`**: Exact name of the server function defined in `app.R`
- **`preload`**: Set to `true` for frequently used modules to reduce first-load time
- **`cache`**: Set to `true` to keep module in memory after first use

---

## Best Practices

### Module Development

#### 1. Use `box::use()` for Imports

Always use explicit imports instead of `library()`:

```r
# Good: Explicit imports
box::use(
  shiny[NS, moduleServer, renderPlot, plotOutput],
  ggplot2[ggplot, aes, geom_point, theme_minimal]
)

# Bad: Global namespace pollution
library(shiny)
library(ggplot2)
```

**Important**: Inside server functions, use the namespace prefix:
```r
my_module_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    # Use shiny$ prefix inside server function
    output$plot <- shiny$renderPlot({
      # Your plot code
    })
  })
}
```

#### 2. Keep Modules Self-Contained

- All data, helpers, and utilities should live in the module folder
- Each module should work standalone without dependencies on other modules
- Document data sources and requirements at the top of `app.R`

#### 3. Document Your Module

Add a header comment to your `app.R`:

```r
# Module Name: Exploratory Data Analysis
#
# Purpose: Interactive visualization of expression data with metadata
#
# Inputs:
#   - metadata_file: CSV with 'sampleName' + covariate columns
#   - matrix_file: CSV with targets (rows) × samples (columns)
#
# Outputs:
#   - Boxplot: Expression by covariate
#   - Heatmap: Top variable features
#   - PCA: Sample relationships
#
# Error modes:
#   - Missing required columns
#   - Sample name mismatch between files
#   - Non-numeric matrix values
#
# Dependencies: shiny, bslib, ggplot2, plotly
```

#### 4. Use Proper Namespacing

Always use `NS()` for all input/output IDs:

```r
my_module_ui <- function(id) {
  ns <- NS(id)  # Create namespace function

  tagList(
    textInput(ns("name"), "Enter name:"),  # Wrap all IDs with ns()
    plotOutput(ns("plot"))
  )
}
```

#### 5. Validate User Inputs

Use `shiny::validate()` and `shiny::need()` for clear error messages:

```r
output$plot <- renderPlot({
  req(input$file)  # Require file upload

  data <- read.csv(input$file$datapath)

  validate(
    need("sampleName" %in% names(data),
         "Error: CSV must contain a 'sampleName' column")
  )

  # Continue with plot...
})
```

---

## Data Management

### File Size Limits

**Important: Do NOT include files totaling >50MB in this repository.**

Large files cause problems with version control, repository cloning, and deployment to hosting services.

### Recommendations

1. **Use sample/synthetic data** for development:
   ```r
   # Include small representative dataset
   sample_data <- data.frame(
     sampleName = paste0("Sample_", 1:10),
     group = rep(c("A", "B"), 5),
     value = rnorm(10)
   )
   ```

2. **Document external data sources**:
   ```r
   # Full dataset available at:
   # https://example.com/data/full_expression_matrix.csv
   # For development, using 100-sample subset
   ```

3. **Prefer processed formats**:
   - Use `.rds` for R objects (smaller, faster)
   - Use `.rda` for multiple objects
   - Compress CSVs if needed

4. **Load data conditionally**:
   ```r
   # Check for external data first
   if (file.exists("data/large_dataset.rds")) {
     data <- readRDS("data/large_dataset.rds")
   } else {
     # Use bundled sample data
     data <- readRDS("R/My_Module/sample_data.rds")
   }
   ```

---

## Testing Your Module

### Standalone Testing

Every module should include a standalone mode at the bottom of `app.R`:

```r
# Standalone mode for development/testing
if (sys.nframe() == 0) {
  shinyApp(
    ui = my_module_ui("test"),
    server = function(input, output, session) {
      my_module_server("test")
    }
  )
}
```

**To test**:
1. Open your module's `app.R` in RStudio
2. Click "Run App"
3. Test functionality in isolation

### Integration Testing

1. Register your module in `modules_list.json`
2. Run the launcher: `shiny::runApp('app_launcher.R')`
3. Select your module from the dropdown
4. Test in the platform context

### Edge Cases to Test

- Empty file uploads
- Mismatched column names
- Non-numeric data in numeric fields
- Duplicate IDs/sample names
- Missing required columns
- Very large inputs (performance)
- Special characters in inputs

---

## Package Management

### Adding New Packages

```r
# Install and lock package version
renv::install("packageName", lock = TRUE)

# For specific versions
renv::install("packageName@1.2.3", lock = TRUE)

# For Bioconductor packages
renv::install("bioc::packageName", lock = TRUE)
```

### Updating Packages

```r
# Update all packages
renv::update()

# Update specific package
renv::update("packageName")

# Snapshot current state
renv::snapshot()
```

### Troubleshooting

```r
# Restore from lockfile (reset to known state)
renv::restore()

# Check package status
renv::status()

# Clean unused packages
renv::clean()
```

---

## Code Quality Guidelines

### Error Handling

```r
# Use try() for operations that might fail
data <- try(read.csv(file_path), silent = TRUE)

if (inherits(data, "try-error")) {
  # Handle error gracefully
  showNotification("Failed to read file", type = "error")
  return(NULL)
}
```

### Logging

```r
box::use(logger[log_info, log_debug, log_warn, log_error])

# Log key events
log_info(sprintf("Module loaded: %d samples", nrow(data)))

# Log warnings
log_warn(sprintf("Missing samples: %s", paste(missing, collapse=", ")))

# Log errors
log_error(sprintf("Failed to process file: %s", error_message))
```

### Performance

```r
# Good: Cache expensive computations
pca_data <- reactive({
  req(input$file)
  # This only recomputes when input$file changes
  compute_pca(read_data(input$file))
})

# Bad: Recompute on every render
output$plot <- renderPlot({
  data <- read_data(input$file)
  pca <- compute_pca(data)  # Runs every time plot updates
  plot(pca)
})
```

### Reactive Programming Tips

1. Use `reactive()` for derived data
2. Use `req()` to require inputs before computation
3. Use `isolate()` to prevent unnecessary reactivity
4. Use `observeEvent()` for side effects
5. Minimize reactive dependencies in render functions

---

## Platform Configuration

### `.Rprofile` Settings

The platform includes optimized defaults:

```r
options(
  repos = c(CRAN = "https://packagemanager.posit.co/cran/latest"),
  shiny.maxRequestSize = 30*1024^2,  # 30MB max upload
  shiny.reactlog = FALSE,            # Disable in production
  shiny.autoreload = FALSE           # Disable in production
)
```

To override for development:
```r
# In your R console (not in module code)
options(shiny.reactlog = TRUE)  # Enable reactivity debugging
```

---

## Deployment

### Local Testing

```bash
# Run with default browser
Rscript -e "shiny::runApp('app_launcher.R', launch.browser = TRUE)"

# Run on specific port
Rscript -e "shiny::runApp('app_launcher.R', port = 3838)"
```

### shinyapps.io

```r
library(rsconnect)

# First time: configure account
rsconnect::setAccountInfo(
  name = "your-account",
  token = "your-token",
  secret = "your-secret"
)

# Deploy
rsconnect::deployApp(
  appDir = ".",
  appName = "small-shiny-apps-platform"
)
```

### Posit Connect

Follow your organization's deployment process. Typically:
```r
rsconnect::deployApp(
  appDir = ".",
  server = "your-connect-server",
  account = "your-account"
)
```

### Docker

Example `Dockerfile`:
```dockerfile
FROM rocker/shiny:latest

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libcurl4-gnutls-dev \
    libssl-dev

# Copy app files
COPY . /srv/shiny-server/app

# Restore R packages
WORKDIR /srv/shiny-server/app
RUN Rscript -e "renv::restore()"

# Expose port
EXPOSE 3838

# Run app
CMD ["R", "-e", "shiny::runApp('/srv/shiny-server/app', port=3838, host='0.0.0.0')"]
```

---

## Module Checklist

Before submitting a new module:

- [ ] Module works standalone (bottom of `app.R` includes test harness)
- [ ] Registered in `modules_list.json` with unique ID
- [ ] Uses `box::use()` for all package imports
- [ ] All IDs wrapped with `ns()` namespace function
- [ ] Input validation with `validate()` and `need()`
- [ ] Error handling for file uploads and data processing
- [ ] Logging for key events (optional but recommended)
- [ ] Documentation header with purpose, inputs, outputs
- [ ] No files >10MB included (use external data references)
- [ ] Tested edge cases (empty inputs, bad data, etc.)
- [ ] Performance optimized (reactive caching, minimal re-renders)

---

## Common Issues

### "Object not found" errors

**Problem**: Functions imported with `box::use()` not found in server function

**Solution**: Use namespace prefix inside server functions:
```r
output$plot <- shiny$renderPlot({ ... })  # Not renderPlot({ ... })
```

### Module doesn't appear in dropdown

Check:
1. Is module registered in `modules_list.json`?
2. Is the `source` path correct?
3. Do `ui` and `server` function names match?
4. Is JSON syntax valid? (Use a validator)

### "ID collision" warnings

**Problem**: Multiple modules using same input/output IDs

**Solution**: Ensure all IDs are wrapped with `ns()`:
```r
textInput(ns("name"), ...)  # Not textInput("name", ...)
```

### Performance issues

**Problem**: App becomes slow with multiple modules

Solutions:
1. Set `preload: false` in `modules_list.json` (lazy loading)
2. Use `reactive()` to cache expensive computations
3. Minimize reactive dependencies in `renderPlot()`/`renderTable()`
4. Profile with `profvis::profvis({ runApp() })`

---

## Support

For questions or issues:

**Sumedh Sankhe**
Email: sumedh.sankhe@gmail.com

---

## Additional Resources

- [Shiny Modules Documentation](https://shiny.rstudio.com/articles/modules.html)
- [box Package Guide](https://klmr.me/box/)
- [renv Documentation](https://rstudio.github.io/renv/)
- [bslib Documentation](https://rstudio.github.io/bslib/)
- [Shiny Performance Best Practices](https://shiny.rstudio.com/articles/performance.html)
