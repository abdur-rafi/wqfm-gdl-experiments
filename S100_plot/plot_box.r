library(ggplot2)
library(dplyr)
library(readr)

# Read merged replicate metrics
box_df <- read_csv("merged_for_plot.csv")

# Harmonize factor ordering to match publication plots
box_df <- box_df %>%
  mutate(
    Method = factor(Method, levels = c("wQFM", "wQMC")),
    DupRate = factor(DupRate, levels = c("0", "0.2", "1", "2", "5")),
    InputType = factor(InputType, levels = c("Input: Est. (100bp)",
                                             "Input: Est. (500bp)")),
    LossRate = factor(LossRate)
  )

# Box plot across replicates with A-pro style aesthetics
p_box <- ggplot(box_df, aes(x = LossRate, y = Error, fill = Method)) +
  geom_boxplot(width = 0.6, position = position_dodge(width = 0.7), outlier.size = 0.8) +
  facet_grid(InputType ~ DupRate, scales = "free_x", space = "free_x") +
  scale_fill_brewer(palette = "Set2", name = "") +
  scale_y_continuous(labels = scales::percent) +
  labs(x = "Loss/Dup rate", y = "Species tree error (NRF)") +
  theme_classic() +
  theme(
    legend.position = "bottom",
    panel.border = element_rect(fill = NA, size = 1)
  )

print(p_box)
