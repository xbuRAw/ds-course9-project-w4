library(caret)

# loading data and setting seed
data(mtcars)
set.seed(111)

# training a random forest using cross validation
rfTrain <- function() {
  return(
    train(mpg ~ ., data = mtcars, method = "rf",
      trControl = trainControl(method = "cv", number = 10)
    )
  )
}

# the prediction function 
rfPredict <- function(model, carParameters) {
  prediction <- predict(model, newdata = carParameters)
  return(prediction)
}