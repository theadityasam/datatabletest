library(data.table)
library(tidyr)

df_wide <- data.table(
  city = c("Mum", "Del", "Kol", "Chn"),
  mayor = c("A", "B", "C", "D"),
  kids = c(43,54,65,76),
  teens = c(20,30,40,50),
  adults = c(23,44,55,66)
)

df_melted <- df_wide%>%gather(age_group, population, -c(city, mayor))