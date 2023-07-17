library(tidyverse)

#loading the dataset
set.seed(123) 
dane <- read.csv("C:/Users/Anastasia/Desktop/PROJEKT2/Portuguese.csv") 
table(is.na(dane))

plot <- ggplot(dane, aes(x = age, y = G3)) + 
  geom_point() + 
  xlab("Variable age") +
  ylab("Final grade")
plot

#creating binary variable; if student has grade greater than 13, it is a good grade (=1), else it is a bad grade (=0)
new_col <- c()

for (i in 1:nrow(dane)) {
  if (dane$G3[i] < 13) {
    new_col <- append(new_col, 1)
  } else {
    new_col <- append(new_col, 0)
  }
}

dane <- cbind(good_grade = new_col, dane)

target <- dane$good_grade
vars <- dane %>% select(-c('G3', 'good_grade'))

#splitting on train and test datasets
test_set_size <- round(0.3 * length(target))
test_set_indices <- sample(seq_along(target), size = test_set_size, replace = FALSE)
train <- dane[-test_set_indices, ]
test <- dane[test_set_indices, ]

summary(train)

plot1 <- ggplot(dane, aes(x = studytime, fill=factor(good_grade))) + 
  geom_bar() + 
  xlab("Variable studytime") +
  ylab("Share of good and bad students")
plot1

plot2 <- ggplot(dane, aes(x = age, fill = factor(good_grade))) + 
  geom_bar() + 
  xlab("Variable age") +
  ylab("Share of good and bad students")
plot2

#checking correlation
a <- train %>% select(c('age', 'Medu', 'Fedu', 'traveltime', 'studytime', 'failures', 'famrel', 'freetime', 'goout', 'Dalc',
                        'Walc', 'health', 'absences', 'G1', 'G2', 'G3'))
correlation <- cor(a)
correlation


big_cor <- matrix(NA, nrow = ncol(correlation), ncol = ncol(correlation))
rownames(big_cor) <- colnames(correlation)
colnames(big_cor) <- colnames(correlation)

for (i in 1:ncol(correlation)) {
  for (j in 1:ncol(correlation)) {
    if (i != j) {
      testing <- cor(a[, i], a[, j])
      big_cor[i, j] <- ifelse(testing > 0.5, "yes", "no")
    } else {
      big_cor[i, j] <- "no"
    }
  }
}

big_cor


#checking variables importance
#install.packages('randomForest')
library(randomForest)

regressor <-randomForest::randomForest(train$good_grade ~ . , data = train, importance=TRUE) # fit the random forest with default parameter
randomForest::importance(regressor, type=1) # get variable importance, based on mean decrease in accuracy

#based on correlation and importance, the variables G1, G2, Dalc and Fedu are dropped
train_selected <- train %>% select(-c('G1', 'G2', 'Fedu', 'Dalc', 'G3'))

regressor1 <-randomForest::randomForest(train_selected$good_grade ~ . , data = train_selected, importance=TRUE) # fit the random forest with default parameter
imp <- randomForest::importance(regressor1, type=1) # get variable importance, based on mean decrease in accuracy
imp <- data.frame(imp)
imp <- cbind(Variables = rownames(imp), imp)
rownames(imp) <- 1:nrow(imp)
imp <- imp %>% relocate(X.IncMSE)
imp2 <- imp[order(imp, decreasing=TRUE), ]
imp2 <- na.omit(imp2)
head(imp2, 15)

#making a regression model
model_alc <- glm(good_grade ~ failures + higher + school + schoolsup + sex + studytime + reason + Medu + Walc + age + freetime + goout, data = train_selected)
summary(model_alc)


predictions_train <- predict(model_alc, train_selected)
mae <- mean(abs(predictions_train - train_selected$good_grade))
print(mae)
mse <- mean((predictions_train - train_selected$good_grade)^2)
print(mse)

#prediction on test dataset
probabilities <- model_alc %>% predict(test, type = "response")
predicted.classes <- ifelse(probabilities > 0.5, 1, 0)
head(predicted.classes, 20)

#checking the accuracy
mean(predicted.classes == test$good_grade)

odds <- exp(coef(model_alc))
odds

library(car)
vif_scores <- car::vif(model_alc)
print(vif_scores)

library(lmtest)
reset_test <- resettest(model_alc)
print(reset_test)

library(pROC)
roc_score=roc(test[,1], predicted.classes) #AUC score
plot(roc_score ,main ="ROC curve - Logistic Regression ")

#ROC score; Area under the curve
auc(roc_score)

rmse <- sqrt(mse)
print(rmse)

