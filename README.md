# London_bikes_hires

Objectif : Visualisation cartographique autour du dataset spData::cycle_hire 

Description :   Développer une app shiny basée sur une carte, qui en utilisant les données du package "spData", data set "cycle_hire" et plus si affinités, permette de:
- Afficher sur la carte les points de location de vélo,
- Colorer les markers selon le nombre de vélo ou de places dispos
- Ajouter un input permettant de n'afficher que les points de location avec plus de X vélos dispos

Bonus : ne pas avoir à redessiner la carte ou les markers quand tu changes les paramètres de coloration/filtre ;)

## App deployée : https://dnagdt.shinyapps.io/london_bikes_hires/

Solutions : 
- Carte : Leaflet, sf
- Traitement de données : dplyr par facilité de developpement -> possible d'optimiser en utilisant data.table
- Mise à jour de la carte sans re-rendering : leafletProxy :
  - Optimisation de la mise à jour des filtres : voir utils/updateMapFiltres
  - Mise à jour des couleurs : voir utils/updateMapColor et leaflet_setStyle_functions.R :
    - Une solution possible via leaflet actuel est de faire un clearMarkers() %>% removeControl(layerId="legend") puis en reconstruisant les markers, legend et group à afficher/cacher (moins rapide)


## Notes

- leaflet_setStyle_functions.R :
  - Des fonctions utilitaires sont importées de https://github.com/rstudio/leaflet/pull/598 : leaflet_setStyle_functions.R
