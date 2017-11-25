library(Sleuth3)
library(ggplot2)

head(case0701)
qplot(Velocity,Distance,data=case0701)
is.numeric(case0701$Velocity)

case0701.lm<-lm(Distance~Velocity,data=case0701)

summary(case0701.lm)

case0701.lm$coefficients
qplot(Velocity,Distance,data=case0701) + geom_abline(slope=.00137,intercept=.4)

ggplot(case0701, aes(x=Velocity, y=Distance)) + 
  geom_point() + 
  geom_smooth(method=lm,se=FALSE) 

ggplot(case0701, aes(x=Velocity, y=Distance)) + 
  geom_point() + 
  geom_smooth(method=lm) 

pred.intervals<-data.frame(predict(case0701.lm,interval="prediction"))
head(pred.intervals)
case0701.df2 <- cbind(case0701, pred.intervals)
head(case0701.df2)

ggplot(case0701.df2, aes(x=Velocity, y=Distance)) + 
  geom_point() + 
  geom_line(aes(y=lwr), color = "blue", linetype = "dashed") +
  geom_line(aes(y=upr), color = "blue", linetype = "dashed") +
  geom_smooth(method=lm)

head(case0701.lm$residuals)

plot(case0701.lm,which=1)
