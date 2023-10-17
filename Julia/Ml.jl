using StatsPlots, Interact,DataFrames,CSV
using Blink
#w = Window()

using Downloads
dataMort=CSV.File(Downloads.download(https://www.kaggle.com/datasets/raskoshik/himalayan-expeditions?select=deaths.csv))
#body!(w, dataviewer(data))
#=
for i in 1:length(data.cause_of_death) #je remplace toute les modalités par leurs 3 premieres lettres
    data.cause_of_death[i]=SubString(data.cause_of_death[i],1:3)
end
replace!(data.cause_of_death, "Fal" => "Chute")
replace!(data.cause_of_death, "Ava" => "Avalanche")
replace!(data.cause_of_death, "AMS" => "MaldesMontagnes")

for i in 1:length(data.cause_of_death)
    if(data.cause_of_death[i] ∉ ["Chute","Avalanche","MaldesMontagnes"])
        data.cause_of_death[i]="Autres"
    end
end
=# 

print(subset(data, :age => a -> a .> 70)) #faire des subsets
using StatsBase
dicAge=(StatsBase.countmap(data.age))
ks=keys(dicAge)
0 ∈ ks

ksM=keys(dicMort)

#methode pour remplacer toutes les modalités de cause_of_death par 4
map_to_Int(s) = SubString(s,1:3) == "AMS" ? "MAM" : SubString(s,1:3) == "Fal" ? "Chute" : SubString(s,1:3) == "Ava" ? "Avalanche" : SubString(s,1:3) == "Exh" ? "Epuisement" 
: SubString(s,1:3) == "Dis" ? "Disparition" : "Autres"
transform!(data, :cause_of_death => ByRow(map_to_Int) => :cause_of_death)


dicMort=(StatsBase.countmap(data.cause_of_death))
data=CSV.read("./ProjetsLogSpe/DataSets/expeditions.csv",DataFrame)
dropmissing!(data,:members)


occursin.("(D)",data[:,"members"])
#aller lire doc regex
vecMembers = split.(data.members,',')
members = vcat(vecMembers...)
morts = members[endswith.(members,"(D)")] #liste des morts 
dataCleanExp=data[!,[2,3,5,6,20,21,26,27,29,30,36,38,46,49,50,52,57]]
dropmissing!(dataCleanExp,:members)
CSV.write("ProjetsLogSpe/DataSets/expeditionsClean.csv",dataCleanExp)

using CSV,Downloads,DataFrames
dt=CSV.File(Downloads.download("https://www.dropbox.com/scl/fi/cpvcr9svg72vg921xc4ih/members.csv?rlkey=kf76mywll5rfp860rhrmass93&dl=0")) |> DataFrame
using Statistics
#j'enlève les valeurs manquantes dans age
dt=dt[dt.age.!="NA",:]
#je transofrme la variable age en vecteur d'entier
dt.age=parse.(Int64, dt.age)

map_to_String(s) = length(s) == 2 ? "Autres" : SubString(s,1:3) == "Ama" ? "Ama Dablam" : SubString(s,1:3) == "Sha" ? "Sharphu" : SubString(s,1:3) == "Ann" ? "Annapurna" : SubString(s,1:3) == "Dha" ? "Dhaulagiri" : SubString(s,1:3) == "Mak" ? "Makalu" : SubString(s,1:3) == "Gan" ? "Ganesh" : SubString(s,1:3) == "Eve" ? "Everest" : SubString(s,1:3) == "Kan" ? "Kangchen" : SubString(s,1:3) == "Pum" ? "Pumori" : SubString(s,1:3) == "Bar" ? "Baruntse" : SubString(s,1:3) == "Lho" ? "Lhotse" : SubString(s,1:3) == "Man" ? "Manaslu" : SubString(s,1:3) == "Cho" ? "Cho" : "Autres"
transform!(dt, :peak_name => ByRow(map_to_String) => :peak_name)
dtClean=dt[!,[1,2,4,5,6,7,8,9,10,11,13,14,15,16,19]]




function drop!(dt::DataFrame,g::Function) #permet de drop toute les lignes qui ne satisfassent pas g
    #selectionne les colonnes type string
    taille=1:length(dt[1,:])
    for j=taille
        if dt[1,j] isa AbstractString
            #verifier la condition sur chaque ligne de cette colonne pour drop avec la fonction g
            filter!(row -> !g(row[j]),dt)
        end
    end
end
#v2
g(x)= x isa AbstractString && x=="NA"
filter(r -> all(!g,r),dtClean) #je filtre par ligne r , et je garde tout celles qui ne sastifassent pas la condition
dtClean=filter(r -> all(!g,r),dtClean) 

map_to_String(s) = length(s) == 2 ? "Autres" :  (occursin("Leader",s) || occursin("leader",s)) ? "Leader" : SubString(s,1:3) == "Cli" ? "Climber" : SubString(s,1:2) == "BC" ? "BaseCampStaff" : (occursin("Tv",s) || occursin("Film",s)) ? "Movie/TV_team" : "Autres"

dtFinal=transform(dtClean, :expedition_role => ByRow(map_to_String) => :expedition_role)

#reste à choisir pour "citizenship" si on garde les doubles nationalités ou non


CSV.write("DataSets/membersClean.csv",dtFinal)
