library(Sleuth3)
case0601.aov<-aov(Score~Handicap,data=case0601)
anova(case0601.aov)
with(case0601,unlist(lapply(split(Score,Handicap),mean)))

with(case0601,unlist(lapply(split(Score,Handicap),length)))

SE<-sqrt(2.6665)*sqrt(1/14+1/14)
SE
qtukey(0.95,5,65)

M <- qtukey(0.95,5,65)/sqrt(2)
M
4.428571-5.921429 - M*SE
4.428571-5.921429 + M*SE

# Put the sample means in s.means.
s.means <- with(case0601,unlist(lapply(split(Score,Handicap),mean)))
# Put the sample sizes in s.size.
s.size <- with(case0601,unlist(lapply(split(Score,Handicap),length)))
# Get all 10 pairs i and j from 1,2,3,4,5.
ij <- combn(5,2)
# Calculate the 10 point estimates.
pt.ests <- s.means[ij[1,]]-s.means[ij[2,]]
# Calculate the 10 SEs. These will all be the same if the sample sizes are equal.
SEs <- sqrt(2.6665)*sqrt(1/s.size[ij[1,]]+1/s.size[ij[2,]])
# Calculate the lower bounds of the Tukey-Kramer 95% confidence intervals
LB <- pt.ests - qtukey(0.95,5,65)*SEs
# Calculate the upper bounds.
UB <- pt.ests + qtukey(0.95,5,65)*SEs
# Display the lower and upper bounds.
cbind(LB,UB)

library(multcomp)

# The function in the multcomp package assumes
# the control is the first level.
summary(case0601$Handicap) # Check the original ordering. "None" is the fourth group.
case0601$Handicap<-relevel(case0601$Handicap,"None") # Put "None" first.
summary(case0601$Handicap) # Check to make sure of the order.

case0601.aov <- aov(Score~Handicap,data=case0601)
case0601.glht<- glht(case0601.aov, linfct=mcp(Handicap="Dunnett"))
confint(case0601.glht)

qf(0.95,4,65)
M <- sqrt(4*qf(0.95,4,65))
M
SE<-sqrt(2.6665)*sqrt((0.5)^2/14+(0.5)^2/14+(0.5)^2/14+(0.5)^2/14)

(5.921429+5.342857 )/2 - (4.428571+4.05)/2 - M*SE
(5.921429+5.342857 )/2 - (4.428571+4.05)/2 + M*SE

alpha=0.05/3 # Set Bonferroni alpha to nominal alpha divided by k.
M <- qt(1-alpha/2,65)

pt.est <- 4.9 - (4.428571+5.921429+4.05+5.342857)/4
SE <- sqrt(2.6665)*sqrt(1/14 + 4*(0.25)^2/14)
pt.est - M*SE
pt.est + M*SE

qt(1-(0.05/10)/2,65)

