server <- function(input, output, session) {
  # chargement du dataset utilisé
  data("cycle_hire")
  # chargement de son dataset complémentaire -> récupération de bbox 
  data("cycle_hire_osm")
  
  # fcts utilisées pour les traitements serveur
  source("utils.R")
  # fcts utilisées pour mettre à jour les couleurs de marqueurs via leafletProxy
  source("leaflet_setStyle_functions.R")
  
  # RV
  values <- reactiveValues(past_min_bikes = 0, # indique la dernière selection du slider, init a 0 comme le slider
                           past_min_empty = 0, # indique la dernière selection du slider, init a 0 comme le slider
                           data = as.data.frame(cycle_hire), # données tabulaires liées au dataset utilisé
                           data_coords = st_coordinates(cycle_hire), # coordonnées des points exploitable par leaflet
                           bbox = sf::st_bbox(cycle_hire_osm) # bounding box du dataset afin de focaliser la carte dessus
  )
  
  # Initialisation de la carte (rendue à 100% de l'ecran) et des marqueurs correspondant à notre jeu de données 
  # Tous les marqueurs sont affichés car les filtres sont initialisés à 0
  # OUTPUT CARTE ----
  output$map <- renderLeaflet({
    createMap(values$data, values$bbox, values$data_coords)
  })
  
  # UPDATES RENDU ----
  ## Update de la carte en fonction des filtres appliqués sur les sliders ----
  observe({
    updateMapFiltres(
      data = values$data,
      input_min_bikes = input$min_bikes,
      input_min_empty = input$min_empty,
      past_min_bikes = values$past_min_bikes,
      past_min_empty = values$past_min_empty
    )
    
    # update des valeurs 
    values$past_min_bikes <- input$min_bikes
    values$past_min_empty <- input$min_empty
  })
  
  ## Update de la couleur des marqueurs ----
  # -> changement de palette OU changement de la variable à colorer
  observe({
    leafletProxy("map", data = values$data) %>%
      updateMapColor(
        data = values$data,
        var_name = switch(input$change_legend,
                          "Vélos" = "nbikes",
                          "Places" = "nempty"),
        palette = input$change_palette,
        legend_title = sprintf("%s disponibles",input$change_legend)
      )
  })
}
