library(Sleuth3)
library(ggplot2)

head(case0501)
summary(case0501$Diet)
qplot(Diet,Lifetime,data=case0501,geom="boxplot")
case0501.aov<-aov(Lifetime~Diet,data=case0501)
case0501.aov
anova(case0501.aov)

t.test(Depth~Year,data=case0201,var.equal=TRUE)
case0201.aov<-aov(Depth~Year,data=case0201)
anova(case0201.aov)
(-4.5833)^2
0.97304^2
166.638/176

nrow(case0501) # Find total sample size
length(unique(case0501$Diet)) # How many different groups?

2546.8/44.6

