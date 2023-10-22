library(shiny)

library(shinythemes)
library(RColorBrewer)
library(reactable)
palette_couleurs <- brewer.pal(12, "Set3")
data <- read.csv("DataSets/membersClean.csv")
data_quanti <- data[,c("age","year")]
data_quali <- data[,c(-2,-5)]
data_binaire <- data_quali[,c(-1,-2,-4,-5)]
# Define UI for app that draws a histogram ----

ui <- fluidPage(
    navbarPage(theme = shinytheme("flatly"),
      "M&N",
      tabPanel("DATA",
               #sidebarPanel(),
               mainPanel(
                            h1("Expeditions_Himalayan"),
                            reactableOutput('dtFinal_data'), 
                            downloadButton('save_data','save to csv')
               ) # mainPanel    
      ),
      navbarMenu("Analyse",
                #tabpanel 1
                tabPanel("Résumés statistiques",
                        sidebarPanel("Informations requises",
                                    selectInput("var1", " Choisissez une variable", choices = names(data)),
                                    conditionalPanel(
                                      condition = "input.var1 == 'age' || input.var1 == 'year'",
                                      radioButtons("bool1","Souhaitez vous regarder une partie de la population?",choices=c('non','oui')),
                                      conditionalPanel(
                                        condition = "input.bool1 == 'oui'",
                                        selectInput("var_quali","Variable à discriminer:",choices = names(data_quali)),
                                        selectInput("cat1","Quel partie de la population souhaitez vous regarder?",choices=NULL)
                                      )
                                    ),
                                    actionButton("run","run")
                        ),
                        mainPanel(h1("Résumé statistiques"),
                                  conditionalPanel(
                                    condition = "input.bool1 == 'non'",
                                    verbatimTextOutput("summary")
                                  ),
                                  conditionalPanel(
                                    condition = "input.bool1 == 'oui' && (input.var1 == 'age' || input.var1 == 'year')",
                                    verbatimTextOutput("sub_summary")
                                  ),
                                  conditionalPanel(
                                      condition = "input.var1 != 'age' && input.var1 != 'year'",
                                      verbatimTextOutput("summary_quali")
                                  )
                        )
                ),
       

                #tabpanel2
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
                                      selectInput("var3", "Choisissez la seconde variable",choices=names(data_quanti)),
                                      radioButtons("bool2","Souhaitez vous regarder une partie de la population?",choices=c('non','oui')),
                                      conditionalPanel(
                                        condition = "input.bool2 == 'oui'",
                                        selectInput("var_binaire","Variable à discriminer:",choices = names(data_binaire))
                                      )
                                    )
                        ),

                        mainPanel(
                                 conditionalPanel(
                                    condition = "input.plot_type == 'Histogram'",
                                    plotOutput('hist')
                                ),
                                conditionalPanel(
                                    condition = "input.plot_type == 'Scatter Plot' && input.bool2 == 'non'",
                                    plotOutput('nuage')
                                ),
                                conditionalPanel(
                                    condition = "input.plot_type == 'Scatter Plot' && input.bool2 == 'oui'",
                                    plotOutput('nuage_qual')
                                )


                        )
                  ),
                  #tabpanel3
                  tabPanel("Graphique quali vs quali",
                          sidebarPanel("Informations requises",
                                      selectInput("var4", " Choisissez une variable", choices = names(data_quali)),
                                      selectInput('plot_type_quali','Choisis le type de graphique:', choices = c('barplot','mosaicplot')),
                                      conditionalPanel(
                                        condition = "input.plot_type_quali == 'mosaicplot'",
                                        selectInput("var5", "Choisissez la 2ème variable",choices=names(data_quali)),
                                        actionButton("run2","run")
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

                  #tabpanel4
                  tabPanel("Graphique quanti vs quali",
                          sidebarPanel("Informations requises",
                                      selectInput("var6", " Choisissez une variable quantitative:", choices = names(data_quanti)),
                                      selectInput("var7","Choisissez une variable qualitative:", choices = names(data_quali)),
                                      selectInput('plot_type_quali_quanti','Choisissez le type de graphique:', choices = c('barplot','boxplot','scatterplot')),
                                      conditionalPanel(
                                        condition = "input.plot_type_quali_quanti == 'barplot'",
                                        radioButtons("bool","Voulez vous que les barres soient empilées?", choices=c('oui','non'))
                                      ),
                                      conditionalPanel(
                                        condition = "input.plot_type_quali_quanti == 'scatterplot'",
                                        selectInput("var8", "Choisissez une deuxième variable quantitative:",choices=names(data_quanti)),
                                        selectInput("cat2","Sur quel modalité voulez vous discriminer?",choices = NULL)
                                      ),
                                      actionButton("run3","run")
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
      ) # navbarMenu
    )#NavBarPage
  ) # fluidPage



server <- function(input, output,session) {
  
  observe({
    var_qualitative <- input$var_quali
    var_qualitative2 <- input$var7
    modalites <- levels(as.factor(data_quali[,var_qualitative]))
    modalites2 <- levels(as.factor(data_quali[,var_qualitative2]))
    # Mettre à jour les choix des selectInput
    updateSelectInput(session, "cat1", choices = modalites)
    updateSelectInput(session, "cat2", choices = modalites2)
  })

  #theme du jeu de donnée
    theme_dark <-reactableTheme(
      color = "hsl(233, 9%, 87%)",
      backgroundColor = "hsl(233, 9%, 19%)",
      borderColor = "hsl(233, 9%, 22%)",
      stripedColor = "hsl(233, 12%, 22%)",
      highlightColor = "hsl(233, 12%, 24%)",
      inputStyle = list(backgroundColor = "hsl(233, 9%, 25%)"),
      selectStyle = list(backgroundColor = "hsl(233, 9%, 25%)"),
      pageButtonHoverStyle = list(backgroundColor = "hsl(233, 9%, 25%)"),
      pageButtonActiveStyle = list(backgroundColor = "hsl(233, 9%, 28%)"))

    df <- reactive({
      reactable(data,
        columns = list(success = colDef(align = "center", style = "color: red;", filterable = FALSE)),
        fullWidth = TRUE,defaultColDef = colDef(style = "font-style: italic;"),searchable = TRUE,
        filterable = TRUE,highlight = TRUE, showPageSizeOptions = TRUE,defaultPageSize = 10,pageSizeOptions = c(10, 50, 100),theme = theme_dark)
    })

    output$dtFinal_data <- renderReactable({
        df()
    })

        #################################Résumés statistiques###########################
        resume <- eventReactive(input$run, {
            summary(data[,input$var1])
        }, ignoreNULL = FALSE)#ignoreNull=false, permet d'afficher sans cliquer sur run

        resume_filtre <-eventReactive(input$run, {
          v1 <- input$var_quali
          v2 <- input$var1
          data_filtre <- data[data[,v1] == input$cat1, ]
          n_observations <- length(data_filtre[,v2])
          frequency <- n_observations / length(data[,v2])#/73000 normalement
          pop <- round(frequency*100,2)
          # Création du résumé personnalisé
          custom_summary <- summary(data_filtre[,v2])
          custom_summary <- c(custom_summary, N_Observations = n_observations, Pourcentage_population = pop)
          round(custom_summary,2)
        }, ignoreNULL = FALSE)

        resume_quali <- eventReactive(input$run, {
          v_quali <- input$var1
        effectifs <- table(data_quali[,v_quali])
        frequence <- round(effectifs/length(data[,v_quali])*100,2)
        frequence_cumulés <- cumsum(frequence)
        table_data <- data.frame(Effectif = as.vector(effectifs), Frequence = as.vector(frequence), Frequence_Cumulees= frequence_cumulés)
        table_data
        },ignoreNULL = FALSE)


    output$summary <- renderPrint({
        resume()
    })

    output$sub_summary <- renderPrint({
        resume_filtre()
    })


    output$summary_quali <- renderPrint({
        resume_quali()
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

    output$nuage_qual <- renderPlot({
      nuageprint <- function(){
        moda <- levels(as.factor(data_binaire[,input$var_binaire]))
        pchs <-  ifelse(data[,input$var_binaire] == moda[1],1,2)
        couleurs <- ifelse(data[,input$var_binaire] == moda[1], "blue","deeppink")
        plot(data_quanti[,input$var2],data_quanti[,input$var3], xlab = input$var2, ylab = input$var3,col = couleurs,pch = pchs)
        legend("topright", legend = moda, 
        pch = c(1,2), col = c("blue","deeppink"),
        , cex = 0.8)
      }
      nuageprint()
    })


 #################################PARTIE QUALITATIF#############################

    #barplot
    output$bar <- renderPlot({
       barplot(table(data[,input$var4]), col = palette_couleurs,las=2)
    })

    #mosaicplot
    output$mosaic <- renderPlot({
      if(input$run2>0)
      isolate(mosaicplot(table(data[,input$var4],data[,input$var5]), col = palette_couleurs, main = paste("MosaicPlot de la variable ",input$var4," et de la variable ",input$var5)))
    })



  
 #################################PARTIE QUANTITATIF vs QUALITATIF##########################
   
   ##boxplot##
    output$box_quali_quanti <- renderPlot({
      boxprint <- function(){
         means <- tapply(data_quanti[, input$var6], data_quali[, input$var7], mean)
          boxplot(data_quanti[,input$var6]~data_quali[,input$var7],col = palette_couleurs,main = paste("boxplot de la variable ",input$var6," en fonction de ",input$var7), ylab = input$var6,xlab = "",las = 2)
          points(x = 1:length(means), y = means, pch = 19, col = "black") #ajout de la moyenne # nolint
      }
      if(input$run3>0){
        isolate(
          boxprint()
        )
      }
    })

    ##barplot##
    
    #barplot empilé
    output$bar_quali_quanti <- renderPlot({
      if(input$run3>0){
        isolate(
          barplot(table(data[,input$var7], data[,input$var6]),beside = FALSE, col = palette_couleurs,legend.text = TRUE, main = paste("Distribution de ",input$var6," par ",input$var7," (barplot empilé)"),
        xlab = input$var6,
        ylab = "Fréquence")
        )
      }
    })

    #barplot non empilé
    output$bar_quali_quanti2 <- renderPlot({
      if(input$run3>0){
        isolate(
          barplot(table(data[,input$var7], data[,input$var6]),beside = TRUE, col = palette_couleurs,legend.text = TRUE, main = paste("Distribution de ",input$var6," par ",input$var7," (barplot non empilé)"),
        xlab = input$var6,
        ylab = "Fréquence")
        )
      }
    })

    #scatterplot
    output$nuage_quali_quanti <- renderPlot({
      data_filtre <- data[data[,input$var7] == input$cat,]
      if(input$run3>0){
        isolate(
          plot(data_filtre[,input$var6],data_filtre[,input$var8],xlab = input$var6, ylab = input$var8,pch=20)
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



