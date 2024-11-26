# UI
library(shiny)
library(spData)
library(dplyr)
library(leaflet)
library(shinyjs)
library(shinythemes)
library(sf)
library(RColorBrewer)
library(shinycssloaders)
ui <- fluidPage(
  useShinyjs(),
  includeCSS("styles.css", encoding = "UTF-8"),
  theme = shinytheme("sandstone"),
  tags$head(tags$script(src = "leaflet_setStyle_functions.js"))
  ,
  shinycssloaders::withSpinner(leafletOutput("map", height = "100vh")),
  absolutePanel(
    id = "abspanel_map_left",
    width = "auto",
    height = "5%",
    draggable = FALSE,
    bottom = 245,
    left = 0,
    div(
      style = "background-color: rgba(255, 255, 255, 0.9);
                padding: 10px;
          border-radius: 10px;
          box-shadow: 0px 4px 12px rgba(0, 0, 0, 0.2);
          margin-left : 10px",
      tags$h5(
        style = "text-align: center;
              margin-bottom: 15px;
              font-size: 18px;
              color: #0ea135;",
        "Paramètres des stations"
      ),
      sliderInput(
        "min_bikes",
        HTML("Nombre de vélos disponibles &ge; :"),
        min = 0,
        max = max(cycle_hire$nbikes),
        value = 0,
        width = "300px",
        step = 1
      ),
      
      sliderInput(
        "min_empty",
        HTML("Nombre de places disponibles &ge; :"),
        min = 0,
        max = max(cycle_hire$nempty),
        value = 0,
        width = "300px",
        step = 1
      )
    )
    
  )
  ,
  absolutePanel(
    id = "abspanel_palette",
    bottom = 220,
    right = 10,
    width = "170px",
    div(
      style = "background-color: rgba(255, 255, 255, 0.7);
                padding: 20px;
          border-radius: 10px;
          box-shadow: 0px 8px 12px rgba(0, 0, 0, 0.1);
          margin-bottom: 15px;",
      selectInput(
        "change_legend",
        label = "Variable à colorer",
        choices = c("Vélos", "Places"),
        selected = "Velos"
      ),
      selectInput(
        "change_palette",
        "Palette",
        choices = rownames(subset(
          brewer.pal.info, category %in% c("seq", "div")
        )),
        selected = "YlGnBu"
      )
    )
    
  )
)