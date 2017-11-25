# Anthony Le
# Homework 2
# 10/11/16

# Exercise 20
# load Sleuth3 package
# view dataset
library(Sleuth3)
ex0112

# subset dataset into separate groups
dataFish<-subset(ex0112,Diet=="FishOil",select=BP)
dataRegular<-subset(ex0112,Diet=="RegularOil",select=BP)

# list each subset
head(dataFish)
head(dataRegular)

# m=mean, sd=standard dev, n=sample size
# 1=Fish Oil group, 2=Regular Oil group
m1<-mean(dataFish$BP)
m2<-mean(dataRegular$BP)
sd1<-sd(dataFish$BP)
sd2<-sd(dataRegular$BP)
n1<-nrow(dataFish)
n2<-nrow(dataRegular)

# degrees of freedom for each sample subset
df1<-(n1-1)
df2<-(n2-1)

#calculate standard error of each sample subset
SE1<-(sd1/sqrt(n1))
SE2<-(sd2/sqrt(n2))

# build 95% confidence interval
CI1<-((qt(0.975,6))*SE1)
CI2<-((qt(0.975,6))*SE2)

# two-sided, one sample t-test of Regular Oil sample group
t.test(dataRegular,var.equal=TRUE)

# Exercise 21
ex0221

# two-sided, two sample t-test, Humerus by Status
t.test(Humerus~Status,data=ex0221,var.equal=TRUE)
