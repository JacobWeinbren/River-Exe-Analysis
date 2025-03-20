# Run this once
library(terra)
large_heatmap <- rast("data/Density Heatmap.tif")
small_heatmap <- aggregate(large_heatmap, fact=10, fun="mean")
writeRaster(small_heatmap, "data/Density_Heatmap_Small.tif", overwrite=TRUE)