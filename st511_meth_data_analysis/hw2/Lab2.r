library(Sleuth3)
with(case0202,hist(Unaffected-Affected))
diffs<-case0202$Unaffected-case0202$Affected
diffs<-with(case0202,Unaffected-Affected)
diffs
hist(diffs)
t.test(diffs)
with(case0202,t.test(Unaffected,Affected,paired=TRUE))
with(case0202,t.test(Unaffected,Affected))
sample.mean<-mean(diffs) #Calculate the sample mean of the differences
sample.sd<-sd(diffs)     #Calculate the sample standard deviation
n<-length(diffs)         #Find the sample size

se.mean<-sample.sd/sqrt(n)    #Calculate the standard error of the sample mean.
sample.mean/se.mean

pt(3.228928,14) # Area under the t_14 curve to the left of 3.228928
1-pt(3.228928,14) # Area to the right.
2*(1-pt(3.228928,14)) # Two-sided p-value.

qt(.975,14) # t quantile for 95% confidence interval and 14 df.
sample.mean-qt(.975,14)*se.mean
sample.mean+qt(.975,14)*se.mean

library(ggplot2)
qplot(factor(Year),Depth,data=case0201,geom="boxplot")

t.test(Depth~Year,data=case0201,var.equal=TRUE)
t.test(Depth~Year,data=case0201,var.equal=TRUE,alternative="less")
