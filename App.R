#########################################################
## River Exe Large Wood Visualisation                  ##
## Created by Jacob Weinbren                           ##
## 2025                                                ##
#########################################################

# Load required packages
library(shiny)
library(leaflet)
library(sf)
library(ggplot2)
library(ggiraph)
library(RColorBrewer)
library(terra)
library(leafem)

# Set maximum file upload size (1GB)
options(shiny.maxRequestSize = 1000 * 1024^2)

# Load all data and preprocessing
source("Global.R")

# Define UI and server logic
source("UI.R")
server <- function(input, output, session) {
    source("Server.R", local = TRUE)
}

# Run the application
shinyApp(ui, server)
