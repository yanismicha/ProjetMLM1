library(shiny)

library(shinythemes)
library(RColorBrewer)
palette_couleurs <- brewer.pal(12, "Set3")
data <- read.csv("DataSets/membersClean.csv")
data_quanti <- data[,c("age","year")]
data_quali <- data[,c(-4,-7)]

# Define UI for app that draws a histogram ----

ui <- fluidPage(theme = shinytheme("flatly"),
    navbarPage(
      # theme = "cerulean",  # <--- To use a theme, uncomment this
      "M&N",
      tabPanel("DATA",
               #sidebarPanel(),
               mainPanel(
                            h1("Votre data"),
                            DT::DTOutput('dtFinal_data'), 
                            downloadButton('save_data','save to csv')
               ) # mainPanel
               
      ), # Navbar 1, tabPanel
      tabPanel("Résumés statistiques",
          sidebarPanel("Informations requises",
              selectInput("var1", " Choisissez une variable", choices = names(data))
          ),
        
          mainPanel(
                    h1("Résumé statistiques"),
                    verbatimTextOutput("summary")
          )
      ),
       

        #navbar2
      tabPanel("Graphique quanti vs quanti",
        sidebarPanel("Informations requises",
              selectInput("var2", " Choisissez une variable:", choices = names(data_quanti)),
              selectInput('plot_type','Choisissez le type de graphique:', choices = c('Histogram','Scatter Plot')),
              conditionalPanel(
                condition = "input.plot_type == 'Histogram'",
                sliderInput(inputId = "Classes",label = "Nombre de classes:", min = 0, max = 50 , value = 16,step = 2)
              ),
              conditionalPanel(
                condition = "input.plot_type == 'Scatter Plot'",
                selectInput("var3", "Choisissez la seconde variable",choices=names(data_quanti))
              )
        ),

        mainPanel(
              conditionalPanel(
                condition = "input.plot_type == 'Histogram'",
                plotOutput('hist')
              ),
              conditionalPanel(
                condition = "input.plot_type == 'Scatter Plot'",
                plotOutput('nuage')
              )

        )
      ),
       #navbar3
      tabPanel("Graphique quali vs quali",
        sidebarPanel("Informations requises",
              selectInput("var4", " Choisissez une variable", choices = names(data_quali)),
              selectInput('plot_type_quali','Choisis le type de graphique:', choices = c('barplot','mosaicplot')),
              conditionalPanel(
                condition = "input.plot_type_quali == 'mosaicplot'",
                selectInput("var5", "Choisissez la 2ème variable",choices=names(data_quali)),
                actionButton("run","run")
              )
        ),

        mainPanel(
              conditionalPanel(
                condition = "input.plot_type_quali == 'barplot'",
                plotOutput('bar')
              ),
              conditionalPanel(
                condition = "input.plot_type_quali == 'mosaicplot'",
                plotOutput('mosaic')
              )

        )
      ),#fin du tabpanel

      #navbar4
      tabPanel("Graphique quanti vs quali",
        sidebarPanel("Informations requises",
              selectInput("var6", " Choisissez une variable quantitative:", choices = names(data_quanti)),

              selectInput("var7","Choisissez une variable qualitative:", choices = names(data_quali)),
              selectInput('plot_type_quali_quanti','Choisissez le type de graphique:', choices = c('barplot','boxplot','scatterplot')),
              conditionalPanel(
                condition = "input.plot_type_quali_quanti == 'barplot'",
                selectInput("bool","Voulez vous que les barres soient empilées?", choices=c('oui','non'))
              ),
              conditionalPanel(
                condition = "input.plot_type_quali_quanti == 'scatterplot'",
                selectInput("var8", "Choisissez une deuxième variable quantitative:",choices=names(data_quanti))
              ),
              actionButton("run2","run")
        ),

        mainPanel(
              conditionalPanel(
                condition = "input.plot_type_quali_quanti == 'boxplot'",
                plotOutput('box_quali_quanti')
              ),
              conditionalPanel(
                condition = "input.plot_type_quali_quanti == 'barplot' && input.bool == 'oui'",
                plotOutput('bar_quali_quanti')
              ),
              conditionalPanel(
                condition = "input.plot_type_quali_quanti == 'barplot' && input.bool == 'non'",
                plotOutput('bar_quali_quanti2')
              ),
               conditionalPanel(
                condition = "input.plot_type_quali_quanti == 'scatterplot'",
                plotOutput('nuage_quali_quanti')
              )

        )
      )#fin du tabpanel
      
      
  
    ) # navbarPage
  ) # fluidPage


# Define server logic required to draw a histogram ----
server <- function(input, output) {

    df <- reactive({
        data
    })

    output$dtFinal_data <- DT::renderDT({
        df()
    })

    #################################PARTIE QUANTITATIF###########################

    # histogramme
    output$hist <- renderPlot({
       x <- data[, input$var2]
       bins <- seq(min(x), max(x), length.out = input$Classes + 1)
       hist(x,breaks = bins,main="histogramme",col="deeppink", xlab = input$var)
    })

    #nuage
    output$nuage <- renderPlot({
        plot(data_quanti[,input$var2],data_quanti[,input$var3], xlab = input$var2, ylab = input$var3)
    })


 #################################PARTIE QUALITATIF#############################

    #barplot
    output$bar <- renderPlot({
       barplot(table(data[,input$var4]), col = palette_couleurs,las=2)
    })

    #mosaicplot
    output$mosaic <- renderPlot({
      if(input$run>0)
      isolate(mosaicplot(table(data[,input$var4],data[,input$var5]), col = palette_couleurs, main = paste("MosaicPlot de la variable ",input$var4," et de la variable ",input$var5)))
    })


    #mosaic
    #resumé stat
    output$summary <- renderPrint({
        summary(data[,input$var1])
    })
  
 #################################PARTIE QUANTITATIF vs QUALITATIF##########################
   
   ##boxplot##
    output$box_quali_quanti <- renderPlot({
      boxprint <- function(){
         means <- tapply(data_quanti[, input$var6], data_quali[, input$var7], mean)
          boxplot(data_quanti[,input$var6]~data_quali[,input$var7],col = palette_couleurs,main = paste("boxplot de la variable ",input$var6," en fonction de ",input$var7), ylab = input$var6)
          points(x = 1:length(means), y = means, pch = 19, col = "black") #ajout de la moyenne
      }
      if(input$run2>0){
        isolate(
          boxprint()
        )
      }
    })

    ##barplot##
    
    #barplot empilé
    output$bar_quali_quanti <- renderPlot({
      if(input$run2>0){
        isolate(
          barplot(table(data[,input$var7], data[,input$var6]),beside = FALSE, col = palette_couleurs,legend.text = TRUE, main = paste("Distribution de ",input$var6," par ",input$var7," (barplot empilé)"),
        xlab = input$var6,
        ylab = "Fréquence")
        )
      }
    })

    #barplot non empilé
    output$bar_quali_quanti2 <- renderPlot({
      if(input$run2>0){
        isolate(
          barplot(table(data[,input$var7], data[,input$var6]),beside = TRUE, col = palette_couleurs,legend.text = TRUE, main = paste("Distribution de ",input$var6," par ",input$var7," (barplot non empilé)"),
        xlab = input$var6,
        ylab = "Fréquence")
        )
      }
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



