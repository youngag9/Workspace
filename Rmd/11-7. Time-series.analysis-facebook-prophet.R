library(tidyverse)
library(zoo)

( df_target <- 
    df_grpByTS.v1 %>% 
    select(sess_dt, order_cnt) %>% 
    rename(ds = sess_dt, y = act_pv) %>% 
    arrange(ds) )

( df_target <- 
    data.frame(ds = as.yearmon(index(USAccDeaths)), 
               y = coredata(USAccDeaths)) 
)

( df_target <- 
    data.frame(ds = as.yearmon(index(Nile)),
               y = coredata(Nile)) 
)

( df_target <- 
    data.frame(ds = as.yearmon(index(AirPassengers)),
               y = coredata(AirPassengers)) 
)

class(df_target$ds)
class(df_target$y)
str(df_target)

#------------------------------------------------------
graphics.off()

# plot(df_target, pch = 1, cex = .5, col = 'red')

library(ggpubr)
ggscatter(data = df_target, 
          x = 'ds', y = 'y', 
          color = 'blue', size = .9, palette = 'jco',
          # add = 'reg.line',
          add = 'loess',
          add.params = list(color = 'red'),
          conf.int = TRUE,
          rug = TRUE
        )

#------------------------------------------------------
library(forecast)
findfrequency(df_target$y)

# library(zoo)
# ( target.ts <- zoo(df_target$y, order.by = df_target$ds) )
( target.ts <- ts(data = df_target$y, 
                  frequency = findfrequency(df_target$y)) )
#-------------
( target.ts <- USAccDeaths )
( target.ts <- Nile )
( target.ts <- AirPassengers )
#-------------
class(target.ts)
start(target.ts)
end(target.ts)
frequency(target.ts)
cycle(target.ts)
tsp(target.ts)

library(forecast)
index(target.ts)
coredata(target.ts)
#-------------------
graphics.off()

library(forecast)

# plot(target.ts)
ts.plot(target.ts)
monthplot(target.ts)

library(colorspace)
( pal <- choose_palette() )

seasonplot(target.ts, year.labels = TRUE, col=pal(12))

tsdisplay(target.ts)
plot(decompose(target.ts))

#------------------------------------------------------
library(prophet)
# ( m <- prophet(df = df_target,
#                yearly.seasonality = 'auto',
#                weekly.seasonality = 'auto',
#                daily.seasonality = 'auto',
#                seasonality.mode = 'additive'
#                # seasonality.mode = 'multiplicative'
#             ) )

( m <- prophet(df = df_target) )

class(m); mode(m) ; names(m)
#--------------
( df_future <- 
    make_future_dataframe(m = m, 
                          periods = 365 
                          # freq = 'day'
                          # freq = 'week'
                          # freq = 'month'      # for USAccDeaths, AirPassengers
                          # freq = 'quarter'
                          # freq = 'year'       # for Nile
                          # freq = 1  # 1 second
                          # freq = 60 # 1 minute
                          # freq = 3600 # 1 hour
                        ) 
  )

str(df_future)
#--------------
( fcst <- predict(object = m, df = df_future) )

class(fcst); mode(fcst) ; str(fcst)

# View(fcst)
tail(fcst[c('ds','yhat','yhat_lower','yhat_upper')], 10)
#--------------
graphics.off()

plot(m, fcst)
prophet_plot_components(m = m, fcst = fcst)
#--------------
graphics.off()

dyplot.prophet(x = m, fcst = fcst, uncertainty = TRUE)
#--------------

