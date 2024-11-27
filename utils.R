library(leaflet)
library(RColorBrewer)
library(dplyr)

# Fonction pour créer la carte initiale
createMap <- function(data,
                       bbox,
                       data_coords,
                       colorpal = "YlGnBu",
                       var_init = "nbikes") {
  pal <- colorNumeric(colorpal, domain = data[[var_init]])
  
  leaflet(data, width = "100%", height = "100%",
          options = leafletOptions(minZoom = 3)) %>%
    fitBounds(
      lng1 = as.numeric(bbox["xmin"]),
      lat1 = as.numeric(bbox["ymin"]),
      lng2 = as.numeric(bbox["xmax"]),
      lat2 = as.numeric(bbox["ymax"])
    ) %>%
    addProviderTiles(providers$CartoDB.Positron,
                     options = providerTileOptions(noWrap = TRUE),
                     group = "POS") %>% addProviderTiles("OpenStreetMap.Mapnik", group = "OSM") %>%
    addProviderTiles("Esri.WorldImagery", group = "ESRI") %>%
    addCircleMarkers(
      lat = data_coords[, "Y"],
      lng = data_coords[, "X"],
      weight = 2,
      radius = 5,
      color = ~ pal(data[[var_init]]),
      fillOpacity = 1,
      popup = ~ paste(
        "Station: ",
        data$name,
        "<br>Vélos disponibles: ",
        data$nbikes,
        "<br>Places disponibles: ",
        data$nempty
      ),
      fillColor = ~ pal(data[[var_init]]),
      layerId = ~ name,
      group = ~ as.character(id) # ainsi lors du "filtrage" on utilise hide or showGroup au lieu de creer et supprimer des marqueurs
    ) %>%
    addLegend(
      "bottomright",
      pal = pal,
      values = data[[var_init]],
      title = "Vélos disponibles",
      opacity = 1,
      layerId = "legend" # à indiquer afin de pouvoir mettre à jour celle-ci correctement via updateMapColor
    ) %>%
    addLayersControl(
      baseGroups = c("POS", "OSM", "ESRI"),
      options = layersControlOptions(collapsed = FALSE)
    )
}

# Fonction pour filtrer efficacement les marqueurs à afficher
# On garde en memoire les dernières selections des slider min_bikes et min_empty afin de ne modifier
# que les marqueurs ayant effectivement fait l'objet d'une mise à jour

updateMapFiltres <- function(data,
                             input_min_bikes,
                             input_min_empty,
                             past_min_bikes,
                             past_min_empty) {
  if (input_min_bikes > past_min_bikes) {
    lapply(
      data %>%
        as.data.frame() %>%
        filter(nbikes < input_min_bikes &
                 nbikes >= past_min_bikes & nempty >=input_min_empty) %>%
        select(id),
      FUN = function(x) {
        leafletProxy("map") %>% hideGroup(group = x)
      }
    )
  } else if (input_min_empty > past_min_empty) {
    lapply(
      data %>%
        as.data.frame() %>%
        filter(nempty < input_min_empty &
                 nempty >= past_min_empty ) %>%
        select(id),
      FUN = function(x) {
        leafletProxy("map") %>% hideGroup(group = x)
      }
    )
  } else if (input_min_bikes < past_min_bikes) {
    lapply(
      data %>%
        as.data.frame() %>%
        filter(nbikes >= input_min_bikes &
                 nbikes < past_min_bikes) %>%
        filter(nempty>=input_min_empty) %>% 
        select(id),
      FUN = function(x) {
        leafletProxy("map") %>% showGroup(group = x)
      }
    )
  } else if (input_min_empty < past_min_empty) {
    lapply(
      data %>%
        as.data.frame() %>%
        filter(nempty >= input_min_empty &
                 nempty < past_min_empty) %>% 
        filter(nbikes>=input_min_bikes) %>% 
        select(id),
      FUN = function(x) {
        leafletProxy("map") %>% showGroup(group = x)
      }
    )
  }
}

# Fonction pour modifier efficacement le style des CircleMarkers colorés utilisés
# pour afficher les stations en fonction des caractéristiques de disponibilités de celle-ci : nbikes et nempty

# Deux cas entrainent une mise à jour :
# 1er cas : un changement de palette de couleur dans le selectinput palette
# 2ème cas : un changement de la variable à colorer dans le selectinput change_legend

updateMapColor <- function(map, data, var_name, palette, legend_title) {
  pal <- colorNumeric(palette, domain = range(data[[var_name]]))
  
  leafletProxy("map", data = data) %>%
    setCircleMarkerStyle(
      layerId = ~ name,
      fillColor = ~ pal(data[[var_name]]),
      color = ~ pal(data[[var_name]])
    ) %>%
    addLegend(
      "bottomright",
      pal = pal,
      values = data[[var_name]],
      title = legend_title,
      opacity = 1,
      layerId = "legend"
    )
}
