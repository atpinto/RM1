
library(ggplot2)
library(Statamarkdown)
stataexe <- "/Applications/Stata/StataBE.app/Contents/MacOS/StataBE"
knitr::opts_chunk$set(engine.path=list(stata=stataexe))
knitr::opts_knit$set(root.dir = 'Data') # Changes the working director to the Data folder
