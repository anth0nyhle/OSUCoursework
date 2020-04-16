library(Sleuth3)
library(ggplot2)

head(case0402)
qplot(Treatment,Time,data=case0402,geom="boxplot")

qplot(Time,data=case0402,geom="histogram",xlim=c(0,300)) + 
  facet_grid(Treatment ~ .)

summary(case0402$Treatment)
wilcox.test(Time~Treatment,data=case0402,alternative="greater",
            exact=FALSE,correct=FALSE)
wilcox.test(Time~Treatment,data=case0402,exact=FALSE,correct=FALSE,
            conf.int=TRUE)

difference<-with(case0202,Unaffected-Affected)
length(difference)
length(which(difference>0))
binom.test(14,15,alternative="greater")

wilcox.test(difference,exact=FALSE,alternative="greater")

head(case0201)
t.test(Depth~Year,data=case0201) # Not assuming equal variance
t.test(Depth~Year,data=case0201,var.equal=TRUE)
