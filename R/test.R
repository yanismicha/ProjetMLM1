library(shiny)
library(DT)
library(shinythemes)
iris$Species <- NULL
# Define UI for app that draws a histogram ----
ui <- fluidPage(
  theme = shinytheme('united'),
  h1("Application test"),
  tags$a("tkt frerot c'est la vida loca", href = "https://www.google.fr"),
  sidebarLayout(
    sidebarPanel(
        selectInput('plot_type','Choisis le type de graphique :', choices = c('Histogram','Scatter Plot')),
         selectInput('var','Choisis une variable :', choices = names(iris)),
         conditionalPanel(
            condition = "input.plot_type == 'Scatter Plot'",
            selectInput('var2','Choisis une deuixème variable :', choices = names(iris))
         )

    ),
    mainPanel(
        tabsetPanel(
               tabPanel('Data',DTOutput('iris_data'), downloadButton('save_data','save to csv')),
               tabPanel('Statistiques',
               verbatimTextOutput('summary'), verbatimTextOutput('summa')),
               tabPanel('Histogramme',
               conditionalPanel(
                condition = "input.plot_type == 'Histogram'",
                 plotOutput('hist')),
                
                conditionalPanel(
                condition = "input.plot_type == 'Scatter Plot'",
                 plotOutput('nuage'))
               )

        )
    )

  )
)

# Define server logic required to draw a histogram ----
server <- function(input, output) {

    df <- reactive({
        iris
    })


    #histogramme
    output$hist <- renderPlot({
        hist(iris[,input$var],main="histogramme",col="deeppink", xlab = input$var)
    })

    output$iris_data <- renderDT({
        df()
    })

    # nuage de points
    output$nuage <- renderPlot({
        plot(iris[,input$var],iris[,input$var2], xlab = input$var, ylab = input$var2)
    })

    #resumé stat
    output$summary <- renderPrint({
        summary(iris)
    })

    #sauvegarde de df au format csv
    output$save_data <- downloadHandler(
        filename <- function(){
            paste("data",Sys.Date(), ".csv", sep = ',')
        },
        content <- function(file){
            write.csv(df(),file)
        }
    )
}

# Create Shiny app ----
shinyApp(ui = ui, server = server)

