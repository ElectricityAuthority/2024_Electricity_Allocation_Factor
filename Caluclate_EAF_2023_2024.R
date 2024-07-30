library(lubridate)
library(dplyr)
library(tidyr)
library(here)

rm(list = ls())
script_path <- dirname(sys.frame(1)$ofile)
setwd(script_path)

physical_trading_nodes <- read.csv('Physical_trading_nodes.csv',header =  T)

price_path <- paste0("vSPD_5.0.2/Output/Done/Basecase/Basecase_PublishedEnergyPrices_TP.csv")
price_base <- read.csv(price_path) %>%
  filter(Pnodename %in% physical_trading_nodes$PointOfConnectionCode) %>%
  separate(DateTime, into = c("TradingDate","TradingTime"), sep = " ") %>%
  mutate(TradingDate = as.Date(TradingDate,'%d-%b-%Y')) %>%
  mutate(TradingPeriod = gsub(x=TradingPeriod,pattern="TP",replacement="")) %>%
  mutate(TradingPeriod = as.integer(TradingPeriod)) %>% 
  transmute(TradingDate,TradingTime,TradingPeriod,
            Node = Pnodename,Price = as.numeric(vSPDDollarsPerMegawattHour))


price_path <- paste0("vSPD_5.0.2/Output/Done/Scenario1/Scenario1_PublishedEnergyPrices_TP.csv")
price_sce1 <- read.csv(price_path) %>%
  filter(Pnodename %in% physical_trading_nodes$PointOfConnectionCode) %>%
  separate(DateTime, into = c("TradingDate","TradingTime"), sep = " ") %>%
  mutate(TradingDate = as.Date(TradingDate,'%d-%b-%Y')) %>%
  mutate(TradingPeriod = gsub(x=TradingPeriod,pattern="TP",replacement="")) %>%
  mutate(TradingPeriod = as.integer(TradingPeriod)) %>% 
  transmute(TradingDate,TradingTime,TradingPeriod,
            Node = Pnodename,Price = as.numeric(vSPDDollarsPerMegawattHour))


price_path <- paste0("vSPD_5.0.2/Output/Done/Scenario2/Scenario2_PublishedEnergyPrices_TP.csv")
price_sce2 <- read.csv(price_path) %>%
  filter(Pnodename %in% physical_trading_nodes$PointOfConnectionCode) %>%
  separate(DateTime, into = c("TradingDate","TradingTime"), sep = " ") %>%
  mutate(TradingDate = as.Date(TradingDate,'%d-%b-%Y')) %>%
  mutate(TradingPeriod = gsub(x=TradingPeriod,pattern="TP",replacement="")) %>%
  mutate(TradingPeriod = as.integer(TradingPeriod)) %>% 
  transmute(TradingDate,TradingTime,TradingPeriod,
            Node = Pnodename,Price = as.numeric(vSPDDollarsPerMegawattHour))

reconciled_load <- read.csv("Reconciled_offtake_by_POC_20230701_20240630.csv") %>%
  transmute(TradingDate = as.Date(TradingDate,'%Y-%m-%d'),
            TradingPeriod = TradingPeriodNumber,
            Node = PointOfConnectionCode, MWh)



DF <- reconciled_load %>% 
  inner_join(price_base, by = c('TradingDate','TradingPeriod','Node')) %>%
  rename(Price_Base = Price) %>%
  inner_join(price_sce1, by = c('TradingDate','TradingPeriod','TradingTime','Node')) %>%
  rename(Price_Sce1 = Price) %>%
  inner_join(price_sce2, by = c('TradingDate','TradingPeriod','TradingTime','Node')) %>%
  rename(Price_Sce2 = Price)


DF1 <- DF %>% filter(!(is.na(MWh) |is.na(Price_Base) | 
                         is.na(Price_Sce1) | is.na(Price_Sce2)
                       )
                     )


results <- DF1 %>% summarise(Demand_MWh = sum(MWh), 
                            Cost_Base = sum(Price_Base * MWh),
                            Cost_Sce1 = sum(Price_Sce1 * MWh),
                            Cost_Sce2 = sum(Price_Sce2 * MWh)
                            ) %>% 
  mutate(LWAP_Base = Cost_Base/ Demand_MWh,
         LWAP_Sce1 = Cost_Sce1/ Demand_MWh,
         LWAP_Sce2 = Cost_Sce2/ Demand_MWh
         ) %>%
  transmute(Year = '2023/2024', Demand_MWh, LWAP_Base, LWAP_Sce1,LWAP_Sce2)

write.csv(results, paste0("TestResults_2023_2024_",format(Sys.time(),"%Y%m%d%H%M"),".csv"),row.names = F)