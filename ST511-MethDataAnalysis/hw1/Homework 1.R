# Anthony Le
# Homework 1
# 10/04/2016

# load Sleuth3 package
# data in exercise 12
library(Sleuth3)
ex0112

# load ggplot2 package
# side-by-side boxplot
library(ggplot2)
ggplot(ex0112,aes(x=Diet,y=BP)) + geom_boxplot(aes(fill=Diet))+ ggtitle("Reduction in BP")

# two-sided t-test
t.test(BP~Diet,data=ex0112,var.equal=TRUE)
