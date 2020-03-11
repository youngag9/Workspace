library(WDI)
gdp <- WDI(
          country = c('US','CA','GB','DE','CN','JP','SG','IL'),
          indicator = c('NY.GDP.PCAP.CD', 'NY.GDP.MKTP.CD'),
          start = 1960,
          end = 2017
        )

#-------------------------------------------------------------

str(gdp)
names(gdp)
names(gdp) <- c('iso2c','Country','Year','PerCapGDP','GDP')

#-------------------------------------------------------------

options(max.print = 99999)
options(scipen = 99)

#-------------------------------------------------------------

head(gdp)

library(dplyr)
sample_n(tbl = gdp, size = 10, replace = FALSE)

#-------------------------------------------------------------

summary(gdp)
table(complete.cases(gdp))

gdp[is.na(gdp$GDP) == TRUE, ]
gdp <- gdp[complete.cases(gdp), ]

#-------------------------------------------------------------

library(ggplot2)
library(scales)

ggplot(data = gdp, aes(x = Year, y = PerCapGDP, color = Country)) +
  geom_line() +
  scale_y_continuous(labels = scales::dollar)

ggplot(data = gdp, aes(x = Year, y = GDP, color = Country)) +
  geom_line() +
  scale_y_continuous(labels = scales::dollar)

#-------------------------------------------------------------

table(gdp$iso2c)

( US <- gdp$PerCapGDP[gdp$iso2c == 'US'] )
( US <- ts(data = US, start = min(gdp$Year), end = max(gdp$Year), frequency = 1) )

plot(
  US,
  main = 'Per Capital GDP of Unites States between 1960 and 2017',
  xlab = 'Year',
  ylab = 'PCAP')

start(US)
end(US)
frequency(US)
end(US) - start(US)

head(US)
tail(US)
summary(US)

library(zoo)
index(US)
coredata(US)

#-------------------------------------------------------------

acf(US)
pacf(US)

#-------------------------------------------------------------

library(forecast)
ndiffs(US)
plot(diff(US, 2))
plot(diff(US, ndiffs(US)))
plot(diff(US, lag = 2))
plot(diff(US, differences = ndiffs(US)))

#-------------------------------------------------------------

library(forecast)
( bestModel <- auto.arima(US) )
summary(bestModel)
confint(bestModel)

( bestModel <- arima(x = US, order = c(1,2,1), fixed = c(NA,NA), transform.pars = FALSE) )
summary(bestModel)
confint(bestModel)

#-------------------------------------------------------------

acf(bestModel$residuals)
acf(resid(bestModel))
acf(residuals(bestModel))

pacf(bestModel$residuals)
pacf(resid(bestModel))
pacf(residuals(bestModel))

#-------------------------------------------------------------

coef(bestModel)
coefficients(bestModel)
confint(bestModel)

library(forecast)
( p <- predict(object = bestModel, n.ahead = 5, se.fit = TRUE) )
p$pred
p$se

#-------------------------------------------------------------

library(forecast)
( forecast <- forecast(object = bestModel, h = 5) )
plot(forecast)

#-------------------------------------------------------------

library(reshape2)
( wideGDP <- 
  dcast(
      data = gdp[, c('iso2c','Year','PerCapGDP')],
      formula = Year ~ iso2c,
      value.var = 'PerCapGDP'
  ) )

library(dplyr)
sample_n(tbl = wideGDP, size = 10, replace = FALSE)
summary(wideGDP)

wideGDP <- wideGDP[-4]
# wideGDP <- wideGDP[, which(colnames(wideGDP) != 'DE')]
summary(wideGDP)

#-------------------------------------------------------------

gdp.ts <- ts(data = wideGDP[-1], start = min(wideGDP$Year), end = max(wideGDP$Year), frequency = 1)
class(gdp.ts)
str(gdp.ts)
head(gdp.ts)

#-------------------------------------------------------------

graphics.off()
plot(gdp.ts, plot.type = 'single', col = 1:7)
legend('topleft', legend = colnames(gdp.ts), ncol = 2, col = 1:7, lty = 1, cex = .9)

#-------------------------------------------------------------

( numDiffs <- ndiffs(gdp.ts) )
( gdp.diffed.ts <- diff(gdp.ts, differences = numDiffs) )

plot(gdp.diffed.ts, plot.type = 'single', col = 1:7)
legend('bottomleft', legend = colnames(gdp.diffed.ts), ncol = 2, lty = 1, col = 1:7, cex = .9)

#-------------------------------------------------------------

library(vars)
( gdpVAR <- VAR(gdp.diffed.ts, lag.max = 12) )

class(gdpVAR)
str(gdpVAR)

gdpVAR$p

names(gdpVAR$varresult)

class(gdpVAR$varresult$CA)
class(gdpVAR$varresult$CN)
class(gdpVAR$varresult$GB)
class(gdpVAR$varresult$IL)
class(gdpVAR$varresult$JP)
class(gdpVAR$varresult$SG)
class(gdpVAR$varresult$US)

gdpVAR$varresult

coef(gdpVAR$varresult$CA)
coef(gdpVAR$varresult$CN)
coef(gdpVAR$varresult$GB)
coef(gdpVAR$varresult$IL)
coef(gdpVAR$varresult$JP)
coef(gdpVAR$varresult$SG)
coef(gdpVAR$varresult$US)

library(coefplot)
coefplot(gdpVAR$varresult$CA)
coefplot(gdpVAR$varresult$CN)
coefplot(gdpVAR$varresult$GB)
coefplot(gdpVAR$varresult$IL)
coefplot(gdpVAR$varresult$JP)
coefplot(gdpVAR$varresult$SG)
coefplot(gdpVAR$varresult$US)

#-------------------------------------------------------------

predict(gdpVAR, n.ahead = 5)

#-------------------------------------------------------------
