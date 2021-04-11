library(testthat)
library(data.table)
library(dplyr)

df_wide <- data.table(
  city = c("Mum", "Del", "Kol", "Chn"),
  mayor = c("A", "B", "C", "D"),
  kids = c(43,54,65,76),
  teens = c(20,30,40,50),
  adults = c(23,44,55,66)
)

df_long <- data.table(
  city = c("Mum", "Del", "Kol", "Chn"),
  age_group = factor(c(rep("mayor", 4),rep("kids", 4), rep("teens", 4), rep("adults", 4)), levels = c("mayor","kids","teens","adults")),
  population = c("A","B","C","D",43, 54, 65, 76, 20, 30, 40, 50, 23, 44, 55, 66)
)

test_that("melt1", {
  expect_warning(df_melted <- melt(data = df_wide, 
                    id.vars = c("city"),
                    variable.name = "age_group",
                    value.name = "population"))
  expect_identical(df_melted, df_long)
})
