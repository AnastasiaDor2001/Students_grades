# Do students' grades depend on their alcohol consumption?
The aim of this project was to find the determinants affecting student performance in two Portuguese schools. The data set contained not only information on alcohol consumption, but also other factors that were taken into account in the model. For this purpose, a dataset of performance data of Portuguese language students was taken. Source: https://www.kaggle.com/datasets/whenamancodes/alcohol-effects-on-study?select=Portuguese.csv

The dataset contains 33 variables such as school name, gender, age, parents' education and job, how often the student drinks and goes out, how much time is dedicated to studying and whether the student is planning higher education. Data exploration and a logistic regression model were performed using R, after that a decision tree and a random forest methods were implemented in Python.

#Data exploration

The data set did not contain any lost data. The data set was divided into training and test sets (70:30), and then the main statistics of the training set were explored. Students are between the ages of 15 and 21, with a median age of 17. The school grading scale starts at 0 and ends at 20, but analyzing the final grade (G3) we see that the maximum score obtained is 19. The median is 12 and on this basis it was decided to turn the variable G3 into a binary variable for better performance of the model. Grades below 13 were categorized as 0, i.e., below average; 13 and above were categorized as 1, i.e., above average.

A few graphs have been made to give an example. For example, we can see that students who dedicate a little time to study are much more numerous than students who study hard. Despite this, there are enough students among them who get above-average grades. Also from another graph we can observe that the majority of students are under 18 years old (Q3). Among them there are also enough students who get grades above average. It is interesting that after 18 years of age most of the students get good grades.

In order to select the best variables for further modeling, the correlation between the numerical variables was examined. As expected, a very strong correlation emerged between semester and year grades (G1, G2, G3) at around 0.8-0.9. There was also a strong correlation between the variables "daily drinking" and "weekend drinking" at around 0.6. The correlation between father's and mother's education was unexpected at level of 0.65.

In addition, the importance of variables was examined. Based on the correlation values, the following variables were excluded: G1, G2, G3, Fedu (father's education), Dalc (daily alcohol consumption). Although Fedu and Dalc were more important than the variables with which they were correlated (Medu - mother's education and Walc - weekend alcohol consumption), the final result of the model with them was worse. The importance of the variables was then measured again. Both times this was done using mean decrease in accuracy.

The following variables were selected to build the model:

* failures - number of past class failures (numeric: n if 1<=n<3, else 4), 
* higher - wants to take higher education (binary: yes or no), 
* school - student's school (binary: 'GP' - Gabriel Pereira or 'MS' - Mousinho da Silveira), 
* schoolsup - extra educational support (binary: yes or no), 
* sex - student's sex (binary: 'F' - female or 'M' - male), 
* studytime - weekly study time (numeric: 1 - <2 hours, 2 - 2 to 5 hours, 3 - 5 to 10 hours, or 4 - >10 hours), 
* reason - reason to choose this school (nominal: close to 'home', school 'reputation', 'course' preference or 'other'), 
* Medu - mother's education (numeric: 0 - none, 1 - primary education (4th grade), 2 - 5th to 9th grade, 3 - secondary education or 4 - higher education), 
* Walc - weekend alcohol consumption (numeric: from 1 - very low to 5 - very high), 
* age, 
* freetime - free time after school (numeric: from 1 - very low to 5 - very high), 
* goout - going out with friends (numeric: from 1 - very low to 5 - very high).

The first few variables were chosen because of their importance, the last few, such as freetime or goout, were chosen according to logic and the idea of student life.

# Creating models
## Logistic regression
After constructing the logistic regression, the important variables were:

failures, higheryes, schoolMS, schoolsupyes, sexM, studytime, reasonreputation, Medu, Walc.

Mean Absolute Error = 0.3746419

Mean Squared Error = 0.1781772

Accuracy = 0.6512821

VIF's of variables from 1.2 to 1.4

Area under the ROC curve: 0.6537

As we can see, variable Walc has some impact on a target variable. Let's try to interpret odds of this variable:

Odds = 1.0431056

A student, consuming more alcohol on weekends, is on average 4.3% more likely to receive a grade below average than a student, consuming less alcohol on weekends.

Let's also interpret variable higheryes. The reference category was 'no'.

Odds = 0.7721112

A student planning to take a higher education has on average 23% lower chance of receiving a below average grade in comparison with a student not planning a higher education.

## Decision tree and Random Forest
Before the implementation of the decision tree and forest, text variables were categorized and coded into numerical variables.
The data set was also divided into training and test sets, after which the method DecisionTreeClassifier was applied.

Mean Absolute Error = 0, however it was decided to optimize the tree a little.

The optimal number of leaf nodes was counted, it amounted to 25. After that RandomForestClassifier method was applied.

roc_auc_score for DecisionTree:  0.7042921686746988

roc_auc_score for RandomForest:  0.7754518072289156

# Conclusion
After creating three models, we were able to find out that drinking on the weekends has a statistically important effect on students' grades. In addition, we managed to optimize the classification method, and Random Forest succeeded the most in this, because its predictive power turned out to be the highest with the value of 77.5%.
