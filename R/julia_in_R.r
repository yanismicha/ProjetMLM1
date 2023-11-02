install.packages("JuliaConnectoR")
library(JuliaConnectoR)
juliaEval('using Pkg; Pkg.add(PackageSpec(name = "Flux", version = "0.12"))'),
juliaEval('using CSV')
juliaEval('using DataFrames')
juliaEval('using Downloads')
juliaEval('dtFinal=CSV.File(Downloads.download("https://www.dropbox.com/scl/fi/d3v41yp6x9cxlqvueoet3/membersClean.csv?rlkey=v9xfdgu6oyubjur9rlu6k9eow&dl=0"),normalizenames = true) |> DataFrame
')
juliaEval('using Pkg; Pkg.add(PackageSpec(name = "PlotlyJS"))')
juliaEval('using PlotlyJS')
juliaEval('plot(dtFinal,x=:age,kind="histogram")')



