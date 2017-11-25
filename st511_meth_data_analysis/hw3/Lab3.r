library(Sleuth3)  # Load the Sleuth3 and ggplot2 packages.
library(ggplot2)

names(case0301)
qplot(Treatment,Rainfall,data=case0301,geom="boxplot")

log.rainfall<-log(case0301$Rainfall) # Calculate the log of Rainfall and call it log.rainfall.

qplot(Treatment,log.rainfall,data=case0301,geom="boxplot") # Make a boxplot using the log-transformed response.

summary(case0301$Treatment) # Check to see which group R puts first.
t.test(log.rainfall~Treatment,data=case0301,var.equal=TRUE,alternative="greater")
log.rain.t.test <- t.test(log.rainfall~Treatment,data=case0301,var.equal=TRUE)
exp(0.2408651)
exp(2.0466973)
exp(1.143781)

C.dalli <- read.csv("C_dalli.csv") # The file must be in your working directory.
head(C.dalli)
qplot(as.factor(time_point),pct_cover,data=C.dalli,geom="boxplot")
logit.pct <- with(C.dalli,log(pct_cover)/(100-pct_cover))
qplot(as.factor(time_point),logit.pct,data=C.dalli,geom="boxplot")

head(case0302)
qplot(Veteran,Dioxin,data=case0302,geom="boxplot")

plot(case0302$Dioxin)
identify(case0302$Dioxin)

summary(case0302$Veteran) # Check R's ordering of the groups.
t.test(Dioxin~Veteran,data=case0302,var.equal=TRUE,
       alternative="less")
t.test(Dioxin~Veteran,data=case0302,var.equal=TRUE,
       alternative="less",subset=-646)
t.test(Dioxin~Veteran,data=case0302,var.equal=TRUE,
       alternative="less",subset=-c(646,645))
