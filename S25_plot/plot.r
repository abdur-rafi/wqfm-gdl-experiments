library(ggplot2)
library(dplyr)
library(readr)

# 1. Read your merged CSV file (output from Python script or manually created)
df <- read_csv("merged_for_plot.csv")

# 2. Ensure factors are correctly ordered for consistent plotting
df <- df %>%
  mutate(
    Method = factor(Method, levels = c("wQFM", "wQMC")),
    DupRate = factor(DupRate, levels = c("0", "0.2", "1", "2", "5")),
    InputType = factor(InputType, levels = c("Input: Est. (100bp)",
                                             "Input: Est. (500bp)"))
  )

# 3. Summarize across replicates → mean + standard error
summary_df <- df %>%
  group_by(Method, DupRate, LossRate, InputType) %>%
  summarise(
    mean_error = mean(Error, na.rm = TRUE),
    se_error = sd(Error, na.rm = TRUE) / sqrt(n()),
    .groups = "drop"
  )

# 4. ❗ Convert LossRate to factor so dup=0 columns (only 1 x-value) shrink correctly
summary_df$LossRate <- as.factor(summary_df$LossRate)

# 5. Plot
p <- ggplot(summary_df, aes(x = LossRate, y = mean_error, color = Method, group = Method)) +
  geom_line() +
  geom_errorbar(aes(ymin = mean_error - se_error,
                    ymax = mean_error + se_error), width = 0.22) +
  geom_point(size = 1) +
  facet_grid(InputType ~ DupRate, scales = "free_x", space = "free_x") +
  scale_color_brewer(palette = "Set2", name = "") +
  scale_y_continuous(labels = scales::percent) +
  labs(x = "Loss/Dup rate", y = "Species tree error (NRF)") +
  theme_classic() +
  theme(
    legend.position = "bottom",
    panel.border = element_rect(fill = NA, size = 1)
  )

print(p)
