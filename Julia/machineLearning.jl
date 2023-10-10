using CSV,Downloads,Plots,DataFrames,ScikitLearn
dtFinal=CSV.File(Downloads.download("https://www.dropbox.com/scl/fi/5gdv6tjn0ojbl1q9d354e/membersClean.csv?rlkey=3x35c1wp23774vk0vr0iygp6c&dl=0")) |> DataFrame
using RDatasets: dataset

#partie scikitlearn
@sk_import linear_model: LogisticRegression
model = LogisticRegression(fit_intercept=true, max_iter = 200)
using ScikitLearn: fit!,score
y=convert(Array,dtFinal[!,:died])
quantitative_feature=["year","age"]
qualitative_feature=names(dtFinal)
filter!(e->e∉quantitative_feature,qualitative_feature) #je garde que les qualitatives
X=dtFinal[!,quantitative_feature]
X=Matrix{Union{AbstractString,Bool}}(dtFinal[!,qualitative_feature])
ScikitLearn.fit!(model,X,y)

#cross_val_score
using ScikitLearn.CrossValidation: cross_val_score
cross_val_score(LogisticRegression(max_iter=130), X, y; cv=5)

using ScikitLearn.GridSearch: GridSearchCV



#partie ml.jl
using MLJ
using MLJ: fit!
X=dtFinal[!,quantitative_feature]
y=dtFinal.died
KNNClassifier = @load KNNClassifier pkg=NearestNeighborModels
model = KNNClassifier()

X.age=coerce(X.age,Continuous)
X.year=coerce(X.year,Continuous)#obligé de changer de type pour le modele
mach = machine(model, X, y)
y=coerce(y,Finite)
test, train = partition(eachindex(y), 0.75, shuffle=true)
fit!(mach,rows=train)
yhat = predict(mach, X[test, :])

prob = map(x->x.prob_given_ref[2], yhat)

scorae = LogLoss(tol=1e-4)(yhat, y[test])

plot(scatter(

    mode="markers",

    X[test,:], x=:x1,y=:x2,

    marker=attr(

        color=prob,

        coloraxis="coloraxis",

        size=12,

        line_width=1.5,

        symbol=y[test],

        cmin=minimum(prob),

        cmax=maximum(prob)

    )

), Layout(showlegend=true, coloraxis_colorscale=colors.RdBu_8))