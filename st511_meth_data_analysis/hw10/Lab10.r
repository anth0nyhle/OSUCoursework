library(Sleuth3)
summary(case0802)

case0802.lm <- lm(log(Time)~Voltage,data=case0802)
summary(case0802.lm)

anova(case0802.lm)

head(case0802.lm$residuals)
sum(case0802.lm$residuals^2)

nrow(case0802)-2

case0802.equalmeans<-aov(log(Time)~1,data=case0802)
anova(case0802.equalmeans)

case0802.aov<-aov(log(Time)~Group,data=case0802)
anova(case0802.aov)

1-pf(0.502,5,69)

anova(case0802.lm,case0802.aov)
