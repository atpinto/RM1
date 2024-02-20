library(readxl)
library(RStata)
library(ggplot2)
options("RStata.StataPath" = "\"C:/Program Files/Stata16/StataIC-64\"")
options("RStata.StataVersion" = 16)
setwd("C:/Users/schlu/Dropbox (Sydney Uni)/BCA Program Restructure/NEW UNITS - development/RM1 development/RM1 learning materials/Data")

### Week 1 ---------------------------------------------------------------------
## Table 3.4
rm(list=ls())
# R
hers <- read_excel("hersdata.xls")
stata_code <- # This is to reproduce random sampling of stata
"
use hersdata, clear
set seed 90896
sample 10
"
hers_subset <- stata(stata_code, data.in=hers, data.out=TRUE)
write.csv(hers_subset, "hers_subset.csv")
lm.hers <- lm(SBP ~ age, data = hers_subset)
summary(lm.hers)

# Prediction and confidence intervals
newdata <- data.frame(age=60)
predict(lm.hers, newdata, interval="confidence")
predict(lm.hers, newdata, interval="prediction")

stata_code <- 
"
reg SBP age
lincom _cons + 60*age

set obs 277
replace age = 60 in 277
predict fitSBP
predict seprSBP, stdf

gen upper =  fitSBP + 1.96*seprSBP in 277
gen lower =  fitSBP - 1.96*seprSBP in 277

list age fitSBP lower upper in 277
"
stata(stata_code, data.in=hers_subset)

# Plot for lecture 1
x <- 1:10
set.seed(1000)
y <- x + rnorm(10, mean=0, sd=2)
df <- data.frame(Age=x,SBP=y)
df$pred <- predict(lm(SBP ~ Age, data = df))

ggplot(df,
       aes(x=Age, y = SBP)) +
  geom_point(size=4, shape=19) +
  geom_smooth(method="lm",se=FALSE, lwd=2) +
  theme_classic() +
  ylab("Systolic Blood Pressure (SBP)") +
  theme(axis.ticks = element_blank()) +
  theme(axis.text = element_blank())
ggsave("Week_01_Lecture_01_Figure_01.jpg", width=4, height=3)

ggplot(df,
       aes(x=Age, y = SBP)) +
  geom_linerange(aes(ymin=pred, ymax=SBP), colour="red", lwd=2) +
  geom_point(size=4, shape=19) +
  geom_smooth(method="lm",se=FALSE, lwd=2) +
  theme_classic() +
  ylab("Systolic Blood Pressure (SBP)") +
  theme(axis.ticks = element_blank()) +
  theme(axis.text = element_blank())
ggsave("Week_01_Lecture_01_Figure_02.jpg", width=4, height=3)

newd <- data.frame(age=seq(min(hers_subset$age),
                             max(hers_subset$age),
                             1))
predictions <- predict(lm.hers, interval="pred"
                       , newd )
newd <- cbind(newd, predictions)

ggplot(hers_subset,
       aes(x = age, y = SBP)) + 
  geom_ribbon(data=newd, aes(ymin=lwr, ymax=upr, y=NULL), alpha=0.1, fill="red") +
  geom_point() + 
  geom_smooth(method="lm") +
  theme_classic() +
  ylab("Systolic Blood Pressure (SBP)") +
  xlab("Age (yrs)") 
ggsave("Week_01_Lecture_02_Figure_01.jpg", width=4, height=3)

ggplot(hers_subset,
       aes(x = age, y = SBP)) + 
  #geom_ribbon(data=newd, aes(ymin=lwr, ymax=upr, y=NULL), alpha=0.1, fill="red") +
  geom_point() + 
  geom_smooth(method="lm", se=FALSE) +
  theme_classic() +
  ylab("Systolic Blood Pressure (SBP)") +
  xlab("Age (yrs)") 
ggsave("Week_01_Lecture_02_Figure_02.jpg", width=4, height=3)
