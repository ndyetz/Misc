library(leaflet)

leaflet() %>% addProviderTiles('Esri.WorldImagery') %>% 
  setView(-105.083,40.57, zoom = 14) %>% 
  addPopups(-105.08, 40.57, 'This is where I currently am!') %>% 
  addPopups(-105.026500, 40.547763, 'This is where I live!')
  
  
leaflet() %>% addProviderTiles('Esri.WorldImagery') %>% 
  setView(-116.779062, 32.806104, zoom = 16) %>% 
  addPopups(-116.779062, 32.806104,  '<center>This is where my parents live!<br>They live in Alpine, CA!</center>')