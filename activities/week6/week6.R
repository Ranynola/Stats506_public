# libraries: ------------------------------------------------------------------
library(tidyverse)

# directories: ----------------------------------------------------------------
path = './Desktop'

# read data
nhanes_demo = sprintf('%s/nhanes_demo.csv', path)
nhanes_ohxden = sprintf('%s/nhanes_ohxden.csv', path)

## Part 1 - Data Prep
### Q1
demo <- read.csv(nhanes_demo)
ohxden <- read.csv(nhanes_ohxden)

### Q2 and Q3
data <- ohxden %>% dplyr::select(SEQN, OHDDESTS) %>% right_join(demo, by = "SEQN") %>%
  dplyr::transmute(id = SEQN, 
                   gender = RIAGENDR, 
                   age = RIDAGEYR, 
                   under_20 = ifelse(age < 20, "Yes", "N0"),
                   college = ifelse(under_20 == "Yes" | !(DMDEDUC2 == 3 | DMDEDUC2 == 4),
                                    "No college/<20",
                                    "some college/college graduate"),
                   exam_status = RIDSTATR, 
                   ohx_status = OHDDESTS) 

### Q4
data <- data %>% mutate(ohx = ifelse(ohx_status == 1 & exam_status == 2,
                                     "Complete", "Missing"))
### Q5
data <- data[data$exam_status == 2,]
