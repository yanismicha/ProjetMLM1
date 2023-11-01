using CSV,Downloads,Plots,DataFrames,ScikitLearn
dtFinal=CSV.File(Downloads.download("https://www.dropbox.com/scl/fi/d3v41yp6x9cxlqvueoet3/membersClean.csv?rlkey=v9xfdgu6oyubjur9rlu6k9eow&dl=0")) |> DataFrame
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
using MLJ,CSV,Downloads,DataFrames
using MLJ: fit!
dtFinal=CSV.File(Downloads.download("https://www.dropbox.com/scl/fi/5gdv6tjn0ojbl1q9d354e/membersClean.csv?rlkey=3x35c1wp23774vk0vr0iygp6c&dl=0")) |> DataFrame
y,X=unpack(dtFinal, ==(:died), in([:year, :age]); rng=123)
X = coerce(X,:age=>Continuous, :year=>Continuous)
schema(X)
y=coerce(y,OrderedFactor)

ms = models(matching(X, y))

#knnclassfier
KNN=@load KNNClassifier
knn=KNN()
mach = machine(knn, X, y) |> fit!
evaluate!(mach, resampling=CV(nfolds=5, shuffle=true, rng=1234),
          measure=[Accuracy()])

K = EnsembleModel(model=knn, n=300)
r1 = range(K, :(model.K), lower=3, upper=10)
          tuned_k = TunedModel(model=K,
                                    tuning=Grid(resolution=12),
                                    resampling=CV(nfolds=6),
                                    ranges=[r1],
                                    measure=Accuracy())        
                                    
          mach = machine(tuned_k, X, y) |> fit!

F = fitted_params(mach)
best_model=F.best_model
          
#DecisionTree
Tree=@load DecisionTreeClassifier pkg=DecisionTree
tree=Tree()
mach = machine(tree, X, y) |> fit!
evaluate!(mach, resampling=CV(nfolds=5, shuffle=true, rng=1234),
          measure=[Accuracy()])
train, test = partition(eachindex(y), 0.7);
mach = machine(tree, X, y)
fit!(mach,rows=train)
evaluate!(mach,
          measure=[Accuracy()])


