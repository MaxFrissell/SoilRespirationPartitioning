## Extracting carbon stock, bulk density, soil clay, and soil type data from SoilGrids

# Selecting the data we want to get from SoilGrids
voi = "ocs" # Organic carbon stock
depth = "0-30cm"
quantile = "Q0.5"
voi_layer = paste(voi, depth, quantile, sep="_")

# Set other variables needed to extract
wcs_path = paste0("https://maps.isric.org/mapserv?map=/map/", voi ,".map") #path on the WCS website
wcs_service = "SERVICE=WCS"
wcs_version = "VERSION=2.0.1"

# Put together everything for a wcs request
wcs = paste(wcs_path,wcs_service,wcs_version,sep="&")

# Make an XML file and save it
l1 <- newXMLNode("WCS_GDAL")
l1.s <- newXMLNode("ServiceURL", wcs, parent=l1)
l1.l <- newXMLNode("CoverageName", "nitrogen_5-15cm_Q0.5", parent=l1)
xml.out = "./sg.xml"
saveXML(l1, file = xml.out)

# Convert into GeoTIFF and save
file.out <- './test.tif'
gdal_translate(xml.out, file.out,
               tr=c(250,250),
               co=c("TILED=YES","COMPRESS=DEFLATE","PREDICTOR=2","BIGTIFF=YES"),
               verbose=TRUE)