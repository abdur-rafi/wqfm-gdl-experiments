library(dplyr)
library(tidyr)

set.seed(123)  # For reproducibility

methods <- c("MulRF", "DupTree", "A-Pro")
duprates <- c("0", "0.2", "1", "2", "5")
lossrates <- c(0, 0.1, 0.5, 1)
input_types <- c("Input: Est. (100bp)", "Input: Est. (500bp)", "Input: true")
replicates <- 1:50

# Create all combinations + replicates
df <- expand.grid(
  Method = methods,
  DupRate = duprates,
  LossRate = lossrates,
  InputType = input_types,
  Replicate = replicates
)

# Add a fake 'Error' value with some pattern + random noise (adjustable)
df <- df %>%
  mutate(
    Error = case_when(
      Method == "MulRF" ~ runif(n(), 0.10, 0.18),
      Method == "DupTree" ~ runif(n(), 0.05, 0.10),
      Method == "A-Pro" ~ runif(n(), 0.02, 0.06)
    )
  )

# Save to CSV
write.csv(df, "data.csv", row.names = FALSE)

cat("✅ data.csv generated with", nrow(df), "rows\n")
