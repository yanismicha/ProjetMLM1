library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "Menu Déroulant avec Pages"),
  dashboardSidebar(
    sidebarMenu(
      sidebarMenu(
        id = "menu_accueil",
        menuItem("Page 1", tabName = "page1"),
        menuItem("Page 2", tabName = "page2"),
        menuItem("Page 3", tabName = "page3")
      ),
      menuItem("Données", tabName = "donnees", icon = icon("database")),
      menuItem("A propos", tabName = "apropos", icon = icon("info"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "page1", "Contenu de la Page 1"),
      tabItem(tabName = "page2", "Contenu de la Page 2"),
      tabItem(tabName = "page3", "Contenu de la Page 3"),
      tabItem(tabName = "donnees", "Contenu des Données"),
      tabItem(tabName = "apropos", "À propos de l'Application")
    )
  )
)

server <- function(input, output) { }

shinyApp(ui, server)
