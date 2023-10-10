using MLJ,DataFrames
iris = load_iris();
selectrows(iris, 1:3)  |> pretty
schema(iris)
iris = DataFrames.DataFrame(iris);
y, X = unpack(iris, ==(:target); rng=123);
first(X, 3) |> pretty
using DecisionTree
Tree = @load DecisionTreeClassifier pkg=DecisionTree
tree=Tree()
evaluate(tree, X, y,resampling=CV(shuffle=true),measures=[log_loss, accuracy],verbosity=0)
mach = machine(tree, X, y)
train, test = partition(eachindex(y), 0.7);
fit!(mach, rows=train);
yhat = predict(mach, X[test,:]);