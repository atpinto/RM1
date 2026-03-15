---
title: "Week2-Exercises-Solutions"
format: 
  pdf:
    documentclass: scrreprt
    keep-md: true
    keep-tex: true
editor_options: 
  chunk_output_type: inline
---



# Exercise solutions

### Week 2 {.unnumbered}

Note that some of these plots are a little difficult to interpret, and there is some flexibility in the decision as to whether an assumption has or has not been met - or to what degree it has been met. The solutions below represent my views on these assumptions.

Recall there are four assumptions of linear regression: linearity, homoscedasticity, normality of residuals, and independence of observations. The last assumption is better checked by investigating the study design - or if there are identification variables in the dataset. As this is simulated data we will focus on the first three assumptions.

For the continuous exposure `x1`, linearity and homoscedasticity can both be checked with a residual versus fitted plot. For the binary outcome `x2`, linearity does not need to be checked as linearity is always met for categorical variables. For homoscedasticity, the residual versus fitted plot is not particularly useful as the points all overlap each other making the graph difficult to interpret. To check homoscedasticity, you should use either boxplots or calculate and compare the standard deviation in each group. The assumption of normally distributed residuals can be checked with either a histogram, or a normal-quantile plot. Example code for Stata and R is shown below. Although it is not strictly needed, it can be helpful to also just plot the data in a scatter plot as well.

Example Stata Code
::: {.cell collectcode='true'}

```{.stata .cell-code}
clear
import delimited "assumptions.csv"
/* For the continuous explanatory variable x1 */
scatter y1 x1 /* scatter plot */
reg y1 x1 /* carry out regression */
rvfplot /* residual versus fitted plot */
predict res_std, residuals /* calculate residuals */
qnorm res_std /* normal quantile plot of residuals */
  
/* For the binary explanatory variable x2 */
graph box y1, over(x2) /* Box plot */
tabulate x2, summarize(y1) /* Calculates the standard deviation in each group */
reg y1 x2 /* carry out regression */
predict res_std_x2, residuals /* calculate residuals */
qnorm res_std_x2 /* normal quantile plot of residuals */
## (encoding automatically selected: ISO-8859-1)
## (6 vars, 100 obs)
## 
## 
## 
##       Source |       SS           df       MS      Number of obs   =       100
## -------------+----------------------------------   F(1, 98)        =    838.06
##        Model |  100.316339         1  100.316339   Prob > F        =    0.0000
##     Residual |  11.7307194        98  .119701218   R-squared       =    0.8953
## -------------+----------------------------------   Adj R-squared   =    0.8942
##        Total |  112.047058        99  1.13178847   Root MSE        =    .34598
## 
## ------------------------------------------------------------------------------
##           y1 | Coefficient  Std. err.      t    P>|t|     [95% conf. interval]
## -------------+----------------------------------------------------------------
##           x1 |   3.555381   .1228145    28.95   0.000      3.31166    3.799102
##        _cons |   .6783011   .0708086     9.58   0.000     .5377838    .8188184
## ------------------------------------------------------------------------------
## 
## 
## 
## 
## 
## 
##             |            Summary of y1
##          x2 |        Mean   Std. dev.       Freq.
## ------------+------------------------------------
##           0 |     1.56612   .36874916          50
##           1 |     3.36748   .70366085          50
## ------------+------------------------------------
##       Total |      2.4668   1.0638555         100
## 
## 
##       Source |       SS           df       MS      Number of obs   =       100
## -------------+----------------------------------   F(1, 98)        =    257.08
##        Model |  81.1224457         1  81.1224457   Prob > F        =    0.0000
##     Residual |  30.9246123        98  .315557269   R-squared       =    0.7240
## -------------+----------------------------------   Adj R-squared   =    0.7212
##        Total |  112.047058        99  1.13178847   Root MSE        =    .56174
## 
## ------------------------------------------------------------------------------
##           y1 | Coefficient  Std. err.      t    P>|t|     [95% conf. interval]
## -------------+----------------------------------------------------------------
##           x2 |    1.80136    .112349    16.03   0.000     1.578407    2.024313
##        _cons |    1.56612   .0794427    19.71   0.000     1.408469    1.723771
## ------------------------------------------------------------------------------
```
:::

Example R code
::: {.cell}

```{.r .cell-code}
# For the continuous explanatory variable x1
plot(y1 ~ x1, data = assumptions) # Scatter plot
```

::: {.cell-output-display}
![](Week2_exerc_sol_files/figure-pdf/unnamed-chunk-2-1.pdf)
:::

```{.r .cell-code}
y1_x1_reg <- lm(y1 ~ x1, data = assumptions) # Carry out regression
plot(y1_x1_reg, 1) # Residual versus fitted plot
```

::: {.cell-output-display}
![](Week2_exerc_sol_files/figure-pdf/unnamed-chunk-2-2.pdf)
:::

```{.r .cell-code}
plot(y1_x1_reg, 2) # Normal quantile plot of residuals
```

::: {.cell-output-display}
![](Week2_exerc_sol_files/figure-pdf/unnamed-chunk-2-3.pdf)
:::

```{.r .cell-code}
# For the binary explanatory variable x2
boxplot(y1 ~ x2, data = assumptions)
```

::: {.cell-output-display}
![](Week2_exerc_sol_files/figure-pdf/unnamed-chunk-2-4.pdf)
:::

```{.r .cell-code}
aggregate( y1 ~ x2, data = assumptions, FUN = sd) # Calculates the standard deviation in each group
```

::: {.cell-output .cell-output-stdout}

```
  x2        y1
1  0 0.3687492
2  1 0.7036609
```


:::

```{.r .cell-code}
y1_x2_reg <- lm(y1 ~ x2, data = assumptions) # Carry out regression
plot(y1_x2_reg, 2)  # Normal quantile plot of residuals
```

::: {.cell-output-display}
![](Week2_exerc_sol_files/figure-pdf/unnamed-chunk-2-5.pdf)
:::
:::

#### Regression between y1 and x1
::: {.cell}

:::
The residua versus fitted plot shows that the linearity assumption is violated in this data. This is because residuals are generally positive for low and high values of `x`, and negative for mid range `x` values. The violation of linearity here makes homoscedasticity more difficult to assess, however as there is no obvious fanning in the residuals, this assumption has been met. The normal quantile plot shows no evidence for a concerning deviation from normality, so the normality of residuals assumption is met.

#### Regression between y2 and x1
The residual versus fitted plot shows that the linearity assumption is met in this data. This is because the residuals are generally scattered around zero for all fitted values. The fanning out pattern in this plot however show that the residual error is increasing for larger fitted values. This shows that that homoscedasticity assumption is violated. The normality of residuals assumption has been met as demonstrated by a reasonably straight line in the normal quantile plot.

#### Regression between y3 and x1
The residual versus fitted plot shows an even scatter around zero for all fitted values that neither fans in our out. Therefore linearity and homoscedasticity are met in this regression. The normal quantile plot also follows a very straight line, showing that the normality of residual assumption has been met.

#### Regression between y4 and x1
The residual versus fitted plot is a little strange on this one. There is on evidence of non-linearity (the residauls don't trend upwards or downwards), and there is no evidence of hetergeniety (as the scatter doesn't fan in or out). However there are larger positive valued residuals than negative valued residuals. This is indicating that the residuals are skewed. The normal quantile plot confirms this with strong departures from normality. This is also evident in a histogram of residuals.

#### Regression between y1 and x2
The boxplot shows different variances for each value of `x2`, so it looks like homoscedasticity might be violated here. The standard deviation is each group is 0.37 and 0.70 - confirming heterogeneity. As `x2` is categorical, we do not need to check linearity. The normal quantile plot of the residuals shows some departures of normality towards the tails, but is reasonably fine - so this assumption is met.

#### Regression between y2 and x2
The boxplot shows different variances for each value of `x2`, so it looks like homoscedasticity might be violated here. The standard deviation is each group is 0.28 and 0.48 - confirming heterogeneity. As `x2` is categorical, we do not need to check linearity. The normal quantile plot of the residuals is fairly straight, and so the assumption of normality is met.

#### Regression between y3 and x2
The bloxplot show relative similar variances for each value of `x2` - so it looks like the homoscedasticity assumption is met here. The calculated standard deviation in each group is 0.34 and 0.39 - a relatively small difference that may be attributable to random variation. So the homoscedasticity assumption is met. As `x2` is categorical, we do not need to check linearity. The normal quantile plot of the residuals is fairly straight, and so the assumption of normality is met.

#### Regression between y4 and x2
The bloxplot show relative similar variances for each value of `x2` - so it looks like the homoscedasticity assumption is met here. The calculated standard deviation in each group is 0.22 and 0.27. The boxplot also shows a few high value outliers, that may indicate the data is skewed. The normal quantile plot does show some departure from normality (particularly for the larger quantiles), but it isn't too extreme. Given the reasonably large dataset (100 observations), the central limit theorem will ensure that a simple linear regression is appropriate here, even with some small depature from normality of the residuals.
