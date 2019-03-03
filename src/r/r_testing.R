library(tidyverse)
library(tibbletime)
library(anomalize)
library(lubridate)
library(forecast)
library(zoo)
library(gridExtra)
setwd("/Users/feiwang/Desktop/capstone/anomalyDetectors/src/r")
tb_all = read_csv("../../output/NYCHA_TS.csv")
tb_all = select(tb_all, c('Building_Meter', 'Month', 'Imputed_KWH'))

# replace all zero values with NA
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


# lots of missing values
account = '1.0 - BLD 01_7836716'
account = '1.0 - BLD 02_7694040'

# no missing value
account = '165.0 - BLD 03_90327795'
  
'102.0 - BLD 02_8107087'

'101.0 - BLD 04_7421675'
'164.0 - BLD 01_96973681'
'2.0 - BLD 20_6477762'
'1.0 - BLD 01_7836716'
'165.0 - BLD 03_90327795'
'1.0 - BLD 01_7836716'


tb =  select(filter(tb_all, Building_Meter == account), 'Month', 'Imputed_KWH')
ggplot(tb, aes(x = Month, y = Imputed_KWH)) + geom_point() + geom_line()


# Forecast package, tsclean for imputation & outlier detection
# convert the tibble to time series object
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

# better visualization to compare the observed and cleaned
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


# tb <- as_tibble(df)





require(graphics)

plot(stl(ts.clean, "per"))
plot(stl(ts.clean, s.window = 12, t.window = 51, t.jump = 1))
ts.stl <- stl(ts.clean, s.window = 13, t.window = 51, t.jump = 1)
ts.stl <- mstl(ts.clean)

ts.orig %>% autoplot()
ts.clean %>% autoplot()


ts.stl1 <- mstl(ts.orig)
ts.stl1 %>% autoplot()

ts.stl2 <- mstl(ts.clean)
ts.stl2 %>% autoplot()


plot(seasonal(ts.stl))
plot(trendcycle(ts.stl))



tb =  select(filter(tb_all, Building_Meter == account), 'Month', 'Imputed_KWH')
tb[is.na(tb$Imputed_KWH), 'Imputed_KWH'] <- 0

ts_anomalized <- tb %>%
  time_decompose(Imputed_KWH, method = "STL", merge = TRUE) %>%
  anomalize(remainder, method = 'iqr', alpha = 0.05) %>%
  time_recompose()
ts_anomalized %>% plot_anomaly_decomposition(alpha_dot = 0.5) +
  ggtitle("Observed & Residuals") 

match(min(tb$Imputed_KWH), ts.orig)
ts.orig
