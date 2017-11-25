library(Sleuth3) # Load the Sleuth3 package. 
help(package=Sleuth3)
case0102

hist(case0102$Salary)
with(case0102,hist(Salary))
with(case0102,hist(Salary[Sex=="Male"]))
with(case0102,hist(Salary[Sex=="Female"]))
with(case0102,hist(Salary[Sex=="Female"],
                   breaks=c(3800,4200,4600,5000,5400,5800,6200,6600)))
help(hist)

# Install ggplot2 before loading it into the library, if needed.
library(ggplot2)
qplot(Sex,Salary,data=case0102,geom="boxplot")
qplot(Sex,Salary,geom="boxplot",data=case0102)
qplot(Salary,Sex,data=case0102,geom="boxplot")

ggplot(case0102,aes(x=Sex,y=Salary)) + geom_boxplot(aes(fill=Sex))
ggplot(case0102,aes(x=Sex,y=Salary)) + geom_boxplot(aes(fill=Sex))+ ggtitle("Starting Salaries")

with(case0102,boxplot(Salary~Sex))

with(case0102,(stem(Salary[Sex=="Male"])))

with(case0102,summary(Salary[Sex=="Female"]))

with(case0102,is.factor(Sex))
with(case0102,summary(Sex))

with(case0102,(sd(Salary[Sex=="Female"])))
t.test(Salary~Sex,alternative="less",data=case0102,var.equal=TRUE)
