library(tidyverse)
library(tibbletime)
library(anomalize)
library(lubridate)
library(forecast)
library(zoo)
library(gridExtra)
library(ggQC)
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
tb
# XmR charts

# plot the two charts in one page
require(gridExtra)

# XmR on residual part
ts_anomalized <- tb %>%
  time_decompose(Imputed_KWH, method = "STL", merge = TRUE)
ts_anomalized <- rename(ts_anomalized, Residual = remainder)

x_Plot <- ggplot(ts_anomalized, aes(x = Month, y = Residual)) + geom_point() + geom_line() + 
  stat_QC(method = 'XmR', auto.label = T, label.digits = 2, show.1n2.sigma = F) 

mR_Plot <- ggplot(ts_anomalized, aes(x = Month, y = Residual)) + stat_mR() + stat_QC_labels(method="mR")

grid.arrange(x_Plot, mR_Plot, nrow=2)


# summarize the control limits
ctrl_limits <- QC_Lines(data = ts_anomalized$Residual, method = "XmR")     
ts_anomalized <- cbind(ts_anomalized, ctrl_limits)

cal_dev <- function(x) {
  if (x$Residual < x$xBar_one_LCL) {
    return(x$xBar_one_LCL - x$Residual)
  } else if (x$Residual > x$xBar_one_UCL) {
    return(x$Residual - x$xBar_one_UCL)
  } else {
    return (NA)
  }
}

dev <- rep(NA, nrow(ts_anomalized))
for (i in 1:nrow(ts_anomalized)) {
  dev[[i]] <- cal_dev(ts_anomalized[i, ])
}
ts_anomalized$Dev = dev

anomalies <- select(arrange(filter(ts_anomalized, !is.na(dev)), desc(dev)), c('Month', 'Imputed_KWH', 'trend', 'season', 'Residual'))
rename(anomalies, Observed = Imputed_KWH, Trend = trend, Seasonal = season)

mutate(ts_anomalized, dev = cal_dev(ts_anomalized))
mutate_all(ts_anomalized, .funs = cal_dev)


# XmR_Plots on original data:
x_Plot <- ggplot(tb, aes(x = Month, y = Imputed_KWH)) + geom_point() + geom_line() + 
  stat_QC(method = 'XmR', auto.label = T, label.digits = 2, show.1n2.sigma = F) 

x_Plot

mR_Plot <- ggplot(tb, aes(x = Month, y = Imputed_KWH)) + stat_mR() + stat_QC_labels(method="mR")
mR_Plot



map_table=tibble(id=c(1,2,3), 
                 value=c("a", "b", "c")
)

map_table

get_label <- function(x) 
{
  res=filter(map_table, id==x)$value
  return(res)
}

# the data to get the label
X_data=tibble(v1=c(1,2,3), 
              v2=c(2,2,2),
              v3=c(3,2,1)
)

X_data

tib_res_2=mutate_all(X_data, .funs = get_label)
tib_res_2
