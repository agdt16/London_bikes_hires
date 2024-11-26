# London_bikes_hires

Objectif : Visualisation cartographique autour du dataset spData::cycle_hire 

Description :   Développer une app shiny basée sur une carte, qui en utilisant les données du package "spData", data set "cycle_hire" et plus si affinités, permette de:
- afficher sur la carte les points de location de vélo,
- colorer les markers selon le nombre de vélo ou de places dispos
- ajouter un input permettant de n'afficher que les points de location avec plus de X vélos dispos

Bonus : ne pas avoir à redessiner la carte ou les markers quand tu changes les paramètres de coloration/filtre ;)

## App deployée : https://dnagdt.shinyapps.io/london_bikes_hires/


## Notes

- leaflet_setStyle_functions.R :
  - Des fonctions utilitaires sont importées de https://github.com/rstudio/leaflet/pull/598 : leaflet_setStyle_functions.R
