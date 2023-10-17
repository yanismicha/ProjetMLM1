using CSV,Downloads,Plots,DataFrames
dtFinal=CSV.File(Downloads.download("https://www.dropbox.com/scl/fi/5gdv6tjn0ojbl1q9d354e/membersClean.csv?rlkey=3x35c1wp23774vk0vr0iygp6c&dl=0")) |> DataFrame



#partie stat
counts = combine(groupby(dtFinal, :peak_name), nrow)  #permet d'avoir le nombre de valeurs prises pour chaque modalités
counts=sort(counts,[order(:nrow)]) #je l'odronne pour que ce soit plus lisible
using Plots
bar(counts.peak_name, counts.nrow, xlabel="Modalité", ylabel="Nombre de valeurs", legend=false)



using StatsPlots
using DataFrames
df = dtFinal
@df df plot(:peak_name,:age)
@df df scatter(:age,:peak_name,title="My DataFrame Scatter Plot!")
#variable age
boxplot(df.age)
dtFinal=CSV.File(Downloads.download("https://www.dropbox.com/scl/fi/5gdv6tjn0ojbl1q9d354e/membersClean.csv?rlkey=3x35c1wp23774vk0vr0iygp6c&dl=0")) |> DataFrame



#partie stat
counts = combine(groupby(dtFinal, :peak_name), nrow)  #permet d'avoir le nombre de valeurs prises pour chaque modalités
counts=sort(counts,[order(:nrow)]) #je l'odronne pour que ce soit plus lisible
using Plots
bar(counts.peak_name, counts.nrow, xlabel="Modalité", ylabel="Nombre de valeurs", legend=false)



using StatsPlots
using DataFrames
df = copy(dtFinal)
@df df plot(:peak_name,:age)
@df df scatter(:age,:peak_name,title="My DataFrame Scatter Plot!")

#variable age
boxplot(df.age)
using StatsBase #pour utiliser les tables de frequence
countsAge = combine(groupby(dtFinal, :age), nrow)  #permet d'avoir le nombre de valeurs prises pour chaque modalités
classe_age = [0, 20,30,40,50,60,70,80,90,100]
using CategoricalArrays,FreqTables

df.age=cut(df.age,classe_age)
countsAge = combine(groupby(df, :age), nrow=> :Freq)#tab des frequences en dataframe
freqAge=freqtable(df,:age)#ou en vecteur
propp=round.(freqAge/length(df.age)*100,digits=2)
# Créez un graphique à barres des proportions
proportions = collect(propp)
bar(classe_age, proportions, xlabel="Catégorie d'âge", ylabel="% Proportion", legend=false)



)
using StatsBase #pour utiliser les tables de frequence
countsAge = combine(groupby(dtFinal, :age), nrow)  #permet d'avoir le nombre de valeurs prises pour chaque modalités
classe_age = [0, 20,30,40,50,60,70,80,90]
using CategoricalArrays,FreqTables

df.age=cut(df.age,classe_age)
countsAge = combine(groupby(df, :age), nrow=> :Freq)#tab des frequences en dataframe
freqAge=freqtable(df,:age)#ou en vecteur
propp=round.(freqAge/length(df.age)*100,digits=2)
# Créez un graphique à barres des proportions
proportions = collect(propp)
bar(classe_age, proportions, xlabel="Catégorie d'âge", ylabel="% Proportion", legend=false)

#variable year
countsYear = combine(groupby(df, :year), nrow=> :Freq)#tab des frequences en dataframe
scatter(countsYear.year,countsYear.Freq,label="Year")

xlabel!("annee")
ylabel!("count")


gr()
@df df scatter(
    :age,
    :year,
    group = :died,
    m = (0.5, [:+ :h :star7], 12),
    bg = RGB(0.2, 0.2, 0.2)
)


freqtable(df,:year,:died)
# aevc des classes pour year
df.year=cut(df.year,1900:20:2020)
freqtable(df,:year)
freqtable(df,:year,:died)


#visualiser des frequences plus facilement
histogram(dtFinal.age,bg_inside = "black",
title = "Frequency of age groups",label = "Age",xlabel = "age")

histogram(dtFinal.year, bg_inside = "black",title = "Frequency of year",label = "Age", xlabel = "age")
#on voit une explosion du nb d'exploration à partir des années 80 surement liés aux avancées technologiques
