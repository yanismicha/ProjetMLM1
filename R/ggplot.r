
library(tidyverse)
library(scales)
library(ggrepel)
library(patchwork)
dt <- read.csv("DataSets/membersClean.csv")
head(dt)
dim(dt)

####GRAPHIQUES QUANTITATIFS###
#classique plot
ggplot(dt, aes(x = year, y = age)) +
  geom_point()
#rajouter du bruit pour une meilleur visu des données
ggplot(dt, aes(x = year, y = age)) +
  geom_point(position = "jitter")

## avec des bacs au lieu de points pour voir les clusters
ggplot(dt, aes(x = year, y = age)) +
  geom_bin2d()


## pour transformer en log sans changer d'echelle ##
ggplot(dt, aes(x = year, y = age)) +
  geom_bin2d() + 
  scale_x_log10() + 
  scale_y_log10()  


##  decoupant notre variable en classes puis boxplot de chaque classe## 
ggplot(dt, aes(y = year)) + 
  geom_boxplot(aes(group = cut_interval(age, 4)),varwidth = TRUE)
#varwidth = TRUE permet d'ajuster la taille de chaque boxplot en proportions


##faire un graphique 2 variables quantitatifs en visualisant selon les modalités d'une qualitative
ggplot(dt, aes(x = year, y = age, size = success)) +
  geom_point()

ggplot(dt, aes(x = year, y = age)) + #color au lieu de size
  geom_point(aes(color = success)) +
  geom_smooth(se = FALSE) + # courbe de regression lisse
  labs( #la legende
    x = "year",
    y = "age",
    color = "success",
    title = "Year en fonction de age",
    caption = "Data from Himalayan Expeditions"
  )
#une ligne par modalités 
ggplot(dt, aes(x = year, y = age,color = sex)) + 
  geom_point()+
  geom_smooth(aes(linetype = sex))



##### mise en evidence d'une modalité!!!####
pluspetite<- function(data, variable){#on recupere la plus petite modalité
  counts <- table(data[,variable])
  names(counts)[which.min(counts)]
}
mod <- pluspetite(dt,"died")
p5 <- ggplot(dt, aes(x = year, y = age)) + 
  geom_point() + 
  geom_point(
    data = dt |> filter(sex == "F"), 
    color = "red"
  ) +
  geom_point(
    data = dt |> filter(sex == "F"), 
    shape = "circle open", size = 3, color = "red"
  ) 


##faire un histogramme##
  p1 <- ggplot(dt, aes(x = age)) +
  geom_histogram(binwidth = 2)

##faire une densité##
p2 <-ggplot(dt, aes(x = age)) +
  geom_density()

##faire un boxplot##
p3 <-ggplot(dt, aes(x = age))+
    geom_boxplot()

##densité par rapport à une variable qualitative##
library(ggridges)

ggplot(dt, aes(x = age, y = citizenship, fill = citizenship, color = citizenship)) +
  geom_density_ridges(alpha = 0.5, show.legend = TRUE) 




## densité 2d##
  ggplot(dt, aes(x = year, y = age)) +
  geom_density_2d()

##trace des sous tracés en fonction des mod d'une qualitative
ggplot(dt, aes(x = year, y = age)) + 
  geom_point() + 
  facet_wrap(~died)

##trace des sous tracés en fonction des mod de 2 qualitatives
ggplot(dt, aes(x = year, y = age)) + 
  geom_point() + 
  facet_grid(sex~died)





###GRAPHIQUES QUALITATIFS##
##barplot ##
ggplot(dt, aes(x = peak_name, fill = peak_name)) + 
  geom_bar() #on peut utiliser color à la place de fill

barsTriees <- function(df, var) {
  df |> 
    mutate({{ var }} := fct_rev(fct_infreq({{ var }})))  |>
    ggplot(aes(x = {{ var }},fill= {{var}})) +
    geom_bar()
}


dt |> barsTriees(citizenship)

##pour changer le nom de y#
dt |>
  count(peak_name) |>
  ggplot(aes(x = peak_name, y = n)) +
  geom_bar(stat = "identity")

## pour avoir un barplot en pourcentage ##
ggplot(dt, aes(x = peak_name, y = after_stat(prop), group = 1)) + 
  geom_bar()


##pour avoir un barplot empilé en fonction d'une autre qualitative ##
ggplot(dt, aes(x = peak_name, fill = success)) + 
  geom_bar()
  ##non empilé##
ggplot(dt, aes(x = peak_name, fill = success)) + 
  geom_bar(position = "dodge")

  ##pour voir les proportions##
ggplot(dt, aes(x = peak_name, fill = expedition_role)) + 
  geom_bar(position = "fill") +
  scale_y_continuous(name = "Pourcentage", labels = label_percent())

##graphique à points contenant les quantités pour chaque modalités 
ggplot(dt, aes(x = peak_name, y = expedition_role)) +
  geom_count()

##heatmap##
dt |> 
  count(season,expedition_role) |>  
  ggplot(aes(x = expedition_role, y = season )) +
  geom_tile(aes(fill = n))


##fonction mosaic##
ggplotmosaic <- function(df,var1,var2){
  df |>
  group_by(var1, var2) %>%
  summarise(count = n()) %>%
  mutate(var1.count = sum(count),
         prop = count/sum(count)) %>%
  ungroup()
  ggplot(df,
       aes(x = var1, y = prop, width = var1.count, fill = var2)) +
  geom_bar(stat = "identity", position = "fill", colour = "black") +
  facet_grid(~var1, scales = "free_x", space = "free_x") +
  scale_fill_brewer(palette = "RdYlGn") +
  theme_void() 
} #ne marche pas en focntion






##Graphique quanti vs quali##

#variation de l'age en fonction du role (en densité pour que ce soit lisible)
ggplot(dt, aes(x = age,y = after_stat(density))) + 
  geom_freqpoly(aes(color = expedition_role))


##box plot (plus facile à interpréter)##
ggplot(dt, aes(x = age , y = fct_reorder(peak_name, age, median), color = peak_name)) +
  geom_boxplot() #fct_reorder permet d'ordonner les boxplot ,ici en fonctiond de la médiane
#pour passer à l'horizontal, suffit d'inverser nos x et y!!


##placer des graphiques côtes à côtes
p1
p2
p3
(p1+p2)/p3






x <- dt$age
y <- dt$season

 ggplot(dt, aes(x = cut(x, breaks = num_classes,labels=labels))) +
            geom_bar(color = "deeppink") +
            labs( #la legende
              x = "year",
              caption = "Data from Himalayan Expeditions"
            ) +
            theme(axis.text.x = element_text(angle = 90, hjust = 1))
num_classes <- 8
breaks <- seq(min(x), max(x), length.out = num_classes + 1)
labels <- paste0("(", round(breaks[-length(breaks)], 0), ",", round(breaks[-1], 0), "]")

levels(cut(year,breaks=breaks,labels=labels))
