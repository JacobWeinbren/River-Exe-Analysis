#########################################################
## River Exe Large Wood Data Preparation               ##
## Created by Jacob Weinbren                           ##
## 2025                                                ##
#########################################################

library(sf)
library(terra)
library(RColorBrewer)

# Function to load and transform spatial data to WGS84
load_spatial_data <- function(filepath, make_valid = FALSE) {
    data <- st_read(filepath, quiet = TRUE)

    # Clean and standardise the data
    if (any(st_is_empty(data))) data <- data[!st_is_empty(data), ]
    data <- st_zm(data, drop = TRUE)
    if (make_valid) data <- st_make_valid(data)

    # Transform to WGS84
    st_transform(data, crs = 4326)
}

# Load all required spatial datasets
lw_points <- load_spatial_data("data/LW.shp")
bridges <- load_spatial_data("data/Bridges.shp")
catchers <- load_spatial_data("data/Catchers.shp")
clusters <- load_spatial_data("data/Clusters.geojson")
river <- load_spatial_data("data/RiverExe.shp", make_valid = TRUE)

# Create vibrant colour palette for clusters
num_clusters <- length(unique(clusters$CLUSTER_ID))
pal_clusters <- colorFactor(
    palette = colorRampPalette(brewer.pal(min(11, num_clusters), "Spectral"))(num_clusters),
    domain = clusters$CLUSTER_ID
)

# Load density heatmap raster (if available)
heatmap_path <- "data/Density_Heatmap_Small.tif"

heatmap <- project(rast(heatmap_path), "EPSG:4326")

# Set up colour range and palette
heatmap_range <- range(values(heatmap), na.rm = TRUE)
rainbow_colors <- rainbow(10, start = 0, end = 0.8)
pal_heatmap <- colorNumeric(
    palette = rainbow_colors,
    domain = heatmap_range,
    na.color = "transparent"
)

# Convert to raster format for leaflet image query
heatmap_raster <- raster(heatmap)
