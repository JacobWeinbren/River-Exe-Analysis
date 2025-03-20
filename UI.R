#########################################################
## River Exe Large Wood UI Definition                  ##
## Created by Jacob Weinbren                           ##
## 2025                                                ##
#########################################################

# Define the UI layout
ui <- navbarPage(
    "Instream Large Wood on the River Exe",
    id = "nav",
    tabPanel(
        "Map",
        div(
            class = "outer",
            leafletOutput("map", height = "calc(100vh - 70px)")
        )
    )
)
