library(cicerone)
guide <- Cicerone$
  new(allow_close = FALSE)$
  step(
    "save_data",
    "Sauvegarder le jeu de données",
    "CLiquez ici pour sauvegarder le jeu de données en format csv."
  )$
  step(
    "summary",
    "resume statistique",
    "Vous trouverez ici le résumé statistique de la variable choisi."
  )