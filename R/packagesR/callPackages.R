if(!require(here)){
  install.packages("here")
}
require(here)
if(!require(JuliaCall)){
  install.packages("JuliaCall")
}
if(!require(shiny)){
  install.packages("shiny")
}
require(shiny)
if(!require(shinydashboard)){
  install.packages("shinydashboard")
}
if(!require(shinythemes)){
  install.packages("shinythemes")
}
if(!require(RColorBrewer)){
  install.packages("RColorBrewer")
}
if(!require(reactable)){
  install.packages("reactable")
}
if(!require(scales)){
  install.packages("scales")
}
if(!require(ggrepel)){
  install.packages("ggrepel")
}
if(!require(ggmosaic)){
  install.packages("ggmosaic")
}
if(!require(patchwork)){
  install.packages("patchwork")
}
path=here()
if(!require(scindeR)){
  install.packages(paste0(path,"R/packagesR/scindeR_0.0.0.9000.tar.gz"), repos = NULL, type = "source")
}
if(!require(compar)){
  install.packages(paste0(path,"R/packagesR/compar_0.0.0.9000.tar.gz"), repos = NULL, type = "source")
}
# if(!require(PredictionPython)){
#   install.packages(paste0(path,"/packagesR/PredictionPython_1.0.tar.gz"), repos = NULL, type = "source")
# }
if(!require(plotly)){
  install.packages("plotly")
}
if(!require(shinyWidgets)){
  install.packages("shinyWidgets")
}
require(shinyWidgets)
require(shinydashboard)
require(shinythemes)
require(RColorBrewer)
require(reactable)
require(scales)
require(ggrepel)
require(ggmosaic)
require(patchwork)
require(scindeR)#permet de scinder ma data en quanti, quali et binaire.
require(compar)#permet de comparer les plots.
require(plotly)
#require(PredictionPython)
require(JuliaCall)
# setwd(path)
# julia <- julia_setup()
# 
# julia_install_package("https://github.com/RobinChaussemy/JuliaPredict.jl.git")
# julia_library("JuliaPredict")