#########################################################
## River Exe Large Wood Server Logic                   ##
## Created by Jacob Weinbren                           ##
## 2025                                                ##
#########################################################

# Create custom icons
icons <- list(
    bridge = awesomeIcons(
        icon = "square",
        iconColor = "white",
        library = "fa",
        markerColor = "purple"
    ),
    catcher = awesomeIcons(
        icon = "exclamation-triangle",
        iconColor = "black",
        library = "fa",
        markerColor = "orange"
    )
)

# Render the leaflet map
output$map <- renderLeaflet({
    leaflet() %>%
        # Base map and view settings
        addProviderTiles(providers$CartoDB.Positron, group = "Legend") %>%
        setView(lng = -3.7, lat = 51.15, zoom = 11) %>%
        # Add river line
        addPolylines(
            data = river,
            color = "#2970FF",
            weight = 4,
            opacity = 0.9,
            group = "River"
        ) %>%
        # Add marker features
        addAwesomeMarkers(
            data = bridges,
            icon = icons$bridge,
            popup = "Bridge",
            group = "Bridges"
        ) %>%
        addAwesomeMarkers(
            data = catchers,
            icon = icons$catcher,
            popup = "Wood Catcher",
            group = "Catchers"
        ) %>%
        # Add large wood clusters
        addCircleMarkers(
            data = clusters,
            fillColor = ~ pal_clusters(CLUSTER_ID),
            color = "#333333",
            weight = 2,
            radius = 8,
            stroke = TRUE,
            fillOpacity = 0.95,
            popup = ~ paste(
                "<div style='font-family:Arial; font-size:12px'>",
                "<b>Cluster ID:</b>", CLUSTER_ID,
                "<br><b>Cluster Size:</b>", CLUSTER_SIZE,
                "<br><b>Type:</b>", LW_Type,
                "</div>"
            ),
            group = "Large Wood"
        ) %>%
        # Add navigation aids
        addScaleBar(position = "bottomleft") %>%
        addMiniMap(
            toggleDisplay = TRUE,
            tiles = providers$CartoDB.Positron,
            position = "bottomright"
        ) %>%
        addControl(
            html = '<div style="text-align:center; font-weight:bold; text-shadow:0 0 3px white;">N<div style="width:0; height:0; margin:0 auto; border-left:10px solid transparent; border-right:10px solid transparent; border-bottom:15px solid black;"></div></div>',
            position = "topright"
        ) %>%
        # Add layer controls
        addLayersControl(
            baseGroups = c("Legend"),
            overlayGroups = c("River", "Bridges", "Catchers", "Large Wood", "Heatmap"),
            options = layersControlOptions(collapsed = FALSE)
        )
})

# Add heatmap layer if available
observe({
    leafletProxy("map") %>%
        addRasterImage(
            heatmap,
            colors = pal_heatmap,
            opacity = 0.8,
            group = "Heatmap"
        ) %>%
        addLegend(
            position = "bottomleft",
            pal = pal_heatmap,
            values = heatmap_range,
            title = "Density",
            opacity = 0.8
        ) %>%
        addImageQuery(
            heatmap_raster,
            layerId = "Heatmap",
            prefix = "Density: ",
            digits = 2,
            position = "topright",
            type = "mousemove"
        )
})
