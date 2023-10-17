library(shiny)
library(DT)
iris$Species <- NULL
data <- read.csv("DataSets/membersClean.csv")
data_quanti <- data[,c("age","year")]
data_quali <- data[,c(-4,-7)]

# Define UI for app that draws a histogram ----
ui <- fluidPage(

  # App title ----
  sidebarLayout(
    sidebarPanel(
        selectInput('var','Choisis une variable :', choices = names(data)),
        conditionalPanel(
            condition = "['year','age'].includes(input.var)",
            selectInput('plot_type','Choisis le type de graphique quanti :', choices = c('Histogram','Scatter Plot')),
            sliderInput(inputId = "bins",
                  label = "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30)
        ),
        conditionalPanel(
            condition = "['expedition_id','member_id','peak_name','season','sex','citizenship','expedition_role','hired',
            'success','solo','oxygen_used','died','injured'].includes(input.var)",
            selectInput('plot_type','Choisis le type de graphique quali:', choices = c('barplot'))
        ),

         conditionalPanel(
            condition = "input.plot_type == 'Scatter Plot'",
            selectInput('var2','Choisis une deuixème variable :', choices = names(data_quanti))
         )




    ),
    mainPanel(
        tabsetPanel(
               tabPanel('Data',DTOutput('dtFinal_data'), downloadButton('save_data','save to csv')),
               tabPanel('Statistiques',
               verbatimTextOutput('summary'),verbatimTextOutput('sum')),
               tabPanel('Histogramme',
               conditionalPanel(
                condition = "input.plot_type == 'Histogram'",
                 plotOutput('hist')),
                
                conditionalPanel(
                condition = "input.plot_type == 'Scatter Plot'",
                 plotOutput('nuage')),
                  
                conditionalPanel(
                condition = "input.plot_type == 'barplot'",
                 plotOutput('bar'))
               )

        )
    )

  )
)

# Define server logic required to draw a histogram ----
server <- function(input, output) {

    df <- reactive({
        data
    })


    #histogramme
    output$hist <- reactive({renderPlot({
         x    <- data[,input$var]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
        hist(x,breaks = bins,main="histogramme",col="deeppink", xlab = input$var)
    })})

    output$dtFinal_data <- renderDT({
        df()
    })

    # nuage de points
    output$nuage <- renderPlot({
        plot(data_quanti[,input$var],data_quanti[,input$var2], xlab = input$var, ylab = input$var2)
    })

    #barplot
    output$bar <- renderPlot({
        barplot(table(as.factor(data_quali[,input$var])))
    })

    #mosaicplot
    

    #resumé stat
    output$summary <- renderPrint({
        summary(data_quanti)
    })
    output$sum <- renderPrint({
        summary(data_quali)
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


