library(Sleuth3)

# What if the sample distributions were *exactly*
# the population distributions?  That is, what if the
# shape of the population distribution is perfectly
# represented by these samples: how poorly would
# the t-test perform?

pop1 <- case0402$Time[case0402$Treatment=="Modified"]
pop2 <- case0402$Time[case0402$Treatment=="Conventional"]


# delta is the true difference in population means
# delta = 0 allows us to see how the tests would 
# perform for these two population distributions if
# the difference in means is zero (i.e. if the null 
# hypothesis for the t-test is true)

delta <- 0


# Shift population 2 so that the mean of population 2 is
# equal to the delta plus the mean of population 1 

pop2 <- pop2 - mean(pop2) + mean(pop1) + delta


# Take samples of size 14 from each group (matching the
# sample sizes in the case study)

n1 <- 14
n2 <- 14


# Perform 'nsim' simulations, each consisting of:
# 1) Drawing (resampling) samples from each of the two
#    populations.
# 2) Performing the t-test and the wilcoxon rank-sum test
#    on each simulated pair of samples.
# 3) Storing the p-values for each test.

nsim <- 10000

pvals.t <- rep(0, nsim)
pvals.w <- rep(0, nsim)
for(i in 1:nsim){
  samp1 <- sample(pop1, n1, replace=T)
  samp2 <- sample(pop2, n2, replace=T)
  
  pvals.t[i] <- t.test(samp1, samp2, var.eq=F)$p.val
  pvals.w[i] <- wilcox.test(samp1, samp2, correct=F)$p.val
}


# Assess the calibration (if delta = 0) or power (if delta != 0)
# of the two tests by examining how many of the resulting 
# p-values are less than the desired significance level alpha
# (default significance level is 0.05)

alpha <- 0.05

mean(pvals.t < alpha)
mean(pvals.w < alpha)

# Commentary: note that when delta = 0, the t-test rejects (i.e.
# produces a p-value < alpha) with probability strikingly close to
# alpha--that is, the t-test is very close to exact, despite the 
# notable departure from normality in these two 'populations'. 

# Of course, this comparison between the wilcoxon and t-test with
# delta = 0 is slightly unfair because the wilcoxon does not test a
# difference in means! This is, in my opinion, why it is challenging 
# to just substitute one test as an 'alternative' for the other: they
# answer very different questions.

# Note also that the departure from normality in the *samples* is not 
# actually terribly unusual for data from a normal population, as 
# demonstrated by the following sets of 11 normal sample histograms
# with the same population mean and variance as the sample mean of 
# the modified treatment group (n = 14 for all histograms).

# If the code below gives you an "Error in plot.new() : figure margins too large"
# try clearing all graphs. Or restart RStudio.
nrep <- 12
par(mfrow=c(4,3))
for(i in 1:11){
  hist(rnorm(n1, mean(pop1), sd(pop1)), breaks=seq(-50, 350, 50), 
       main="Normal Random Sample")
}
hist(pop1, breaks=seq(-50, 350, 50),  main="Modified Treatment Group")


nrep <- 12
par(mfrow=c(4,3))
for(i in 1:11){
  hist(rnorm(n1, mean(pop1), sd(pop1)), breaks=seq(-50, 350, 25), 
       main="Normal Random Sample")
}
hist(pop1, breaks=seq(-50, 350, 25),  main="Modified Treatment Group")
