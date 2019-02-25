library(tidyverse)
library(tibbletime)
library(anomalize)
library(lubridate)
library(forecast)

tb_all = read_csv("../../output/NYCHA_TS.csv")
tb_all = select(tb, c('Building_Meter', 'Month', 'Imputed_KWH'))

tb_all <- na_if(tb_all, 0)

accounts = tb_all %>% group_by(Building_Meter) 
accounts <- accounts %>% summarise(counts = n(), na_counts = sum(is.na(Imputed_KWH)))
accounts <- accounts %>% summarise(counts = n(), na_counts = sum(Imputed_KWH == 0))
accounts <- filter(accounts, counts - na_counts >= 50)
accounts <- mutate(accounts, na_perc = na_counts/counts)
accounts
summary(accounts$na_perc)
dim(accounts[accounts$na_counts == 0, ])
head(accounts[accounts$na_counts == 0, ])


dim(accounts)

filter(accounts, na_perc > 0.1)



account = '1.0 - BLD 01_7836716'
'101.0 - BLD 04_7421675'
'164.0 - BLD 01_96973681'
'2.0 - BLD 20_6477762'
'1.0 - BLD 01_7836716'
'165.0 - BLD 03_90327795'
'1.0 - BLD 01_7836716'


tb =  select(filter(tb_all, Building_Meter == account), 'Month', 'Imputed_KWH')
ggplot(tb, aes(x = Month, y = Imputed_KWH)) + geom_point() + geom_line()


# Forecast package, tsclean for imputation & outlier detection
tb <- tb[order(tb$Month), ]
ts.orig <- ts(tb$Imputed_KWH, start = c(year(min(tb$Month)), month(min(tb$Month))),, frequency = 12)
ts.clean <- tsclean(ts.orig)
ts.plot(ts.orig, ts.clean, gpars = list(col = c("red", "blue")))


# define a function to convert ts to dataframe
ts_to_df <- function(ts) {
  data.frame(month = as.Date(as.yearmon(time(ts))), value = as.matrix(ts))
}
df.orig <- ts_to_df(ts.orig)
df.clean <- ts_to_df(ts.clean)

df <- cbind(df.orig, df.clean[, 2])
colnames(df) <- c('month', 'value.orig', 'value.forecasted')
df <- mutate(df, value.diff = value.forecasted - value.orig)
filter(df, value.diff != 0)

ggplot() +
  geom_line(data = df.orig, aes(x = month, y = value), color = "red") +
  geom_point(data = df.orig, aes(x = month, y = value), color = "red") +
  geom_line(data = df.clean, aes(x = month, y = value), color = "blue") +
  geom_point(data = df.clean, aes(x = month, y = value), color = "blue") +
  xlab('Month') +
  ylab('KWH Consumptions')


grid.arrange(
    ggplot(df.orig, aes(x = month, y = value)) + geom_point() + geom_line()   
  , ggplot(df.clean, aes(x = month, y = value)) + geom_point() + geom_line()
  )


tb <- as_tibble(df)


# XmR charts

# plot the two charts in one page
require(gridExtra)

# XmR on residual part
ts_anomalized <- tb %>%
  time_decompose(value.forecasted, method = "STL", merge = TRUE)

x_Plot <- ggplot(ts_anomalized, aes(x = month, y = remainder)) + geom_point() + geom_line() + 
  stat_QC(method = 'XmR', auto.label = T, label.digits = 2, show.1n2.sigma = F) 

mR_Plot <- ggplot(ts_anomalized, aes(x = month, y = remainder)) + stat_mR() + stat_QC_labels(method="mR")

grid.arrange(x_Plot, mR_Plot, nrow=2)


# summarize the control limits
QC_Lines(data = ts_anomalized$remainder, method = "XmR")     



x_Plot <- ggplot(tb, aes(x = Month, y = Imputed_KWH)) + geom_point() + geom_line() + 
  stat_QC(method = 'XmR', auto.label = T, label.digits = 2, show.1n2.sigma = F) 

x_Plot

mR_Plot <- ggplot(tb, aes(x = Month, y = Imputed_KWH)) + stat_mR() + stat_QC_labels(method="mR")
mR_Plot



require(graphics)

plot(stl(ts.clean, "per"))
plot(stl(ts.clean, s.window = 12, t.window = 50, t.jump = 1))
