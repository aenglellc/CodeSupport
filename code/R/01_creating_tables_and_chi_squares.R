# File:     01_creating_tables_and_chi_squares.R
# Project:  Patreon
# Author:   Erika Austhof
# Last Update: 10/1/2022
# Data Needed:  StateData.xlsx

# INSTALL AND LOAD PACKAGES ################################

# pacman must already be installed; then load contributed
# packages (including pacman) with pacman
pacman::p_load(pacman, rio, tidyverse, here, skimr, tidyverse, gtsummary, rstatix, janitor, scales, flextable)

# LOAD AND PREPARE DATA ####################################

# Save categorical variables
df <- import("data/StateData.xlsx") %>%
  as_tibble() %>%
  select(state_code, region, psychRegions) %>%
  mutate(psychRegions = as.factor(psychRegions)) %>%
  print()

# ANALYZE DATA #############################################

# Create contingency table
ct <- table(df$region, df$psychRegions)
ct

# Call also get cell, row, and column %
# With rounding to get just 2 decimal places
# Multiplied by 100 to make %

p_load(magrittr)  # To get arithmetic aliases

# Row percentages
ct %>%
  prop.table(1) %>%  # 1 is for row percentages
  round(2) %>%
  multiply_by(100)

# Column percentages
ct %>%
  prop.table(2) %>%  # 2 is for columns percentages
  round(2) %>%
  multiply_by(100)

# Total percentages across the whole set
ct %>%
  prop.table() %>%  # No argument for total percentages
  round(2) %>%
  multiply_by(100)

# Create a table with frequencies and percentages across rows using tabyl and janitor packages
df %>%                                        # data frame
  tabyl(region, psychRegions) %>%             # cross-tabulate counts
  adorn_totals(where = "row") %>%             # add a total row
  adorn_percentages(denominator = "col") %>%  # convert to proportions
  adorn_pct_formatting() %>%                  # convert to percents
  adorn_ns(position = "front") %>%            # display as: "count (percent)"
  adorn_title(                                # adjust titles
    row_name = "Region",
    col_name = "PsychRegions")

# If you want a cleaned up version of the R table, you can pass the above into flextable
df %>%                                        # data frame
  tabyl(region, psychRegions) %>%             # cross-tabulate counts
  adorn_totals(where = "row") %>%             # add a total row
  adorn_percentages(denominator = "col") %>%  # convert to proportions
  adorn_pct_formatting() %>%                  # convert to percents
  adorn_ns(position = "front") %>%            # display as: "count (percent)"
  adorn_title(                                # adjust titles
    row_name = "Region",
    col_name = "PsychRegions",
    placement = "combined") %>% # this is necessary to print as image
  flextable::flextable() %>%    # convert to pretty image
  flextable::autofit()          # format to one line per row 

# Chi-squared testj (but n is small)
tchi <- chisq.test(ct)
tchi

# Additional tables
tchi$observed   # Observed frequencies (same as ct)
tchi$expected   # Expected frequencies
tchi$residuals  # Pearson's residual
tchi$stdres     # Standardized residual

# CLEAN UP #################################################

# Clear environment
rm(list = ls()) 

# Clear packages
p_unload(all)  # Remove all add-ons

# Clear console
cat("\014")  # ctrl+L

# Clear environment, clear mind :)
