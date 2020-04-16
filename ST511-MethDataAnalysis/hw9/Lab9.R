library(Sleuth3)

case0701.lm<-lm(Distance~Velocity,data=case0701)

predict(case0701.lm,newdata=data.frame(Velocity=800),interval="confidence")
data.frame(Velocity=800)

predict(case0701.lm,newdata=data.frame(Velocity=c(800,900,1000)),interval="confidence")

predict(case0701.lm,newdata=data.frame(Velocity=800),interval="confidence",level=0.9)

predict(case0701.lm,newdata=data.frame(Velocity=800),interval="prediction")

summary(case0701.lm)
0.3991704/0.1186662
2*(1-pt(3.363809,22))

case0701.noint<-lm(Distance~Velocity-1,data=case0701)
summary(case0701.noint)

0.0019214 - qt(0.975,23)*0.0001913
0.0019214 + qt(0.975,23)*0.0001913

plot(case0701.lm,which=2)
