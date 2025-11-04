library(ggplot2)
library(dplyr)
library(readr)

# Load replicate-level data
box_df <- read_csv("merged_for_plot.csv")

selected_taxa <- c("Taxa: 500")
selected_ils <- c("ILS: 70%")
selected_dup <- c("dup: 0.25", "dup: 1", "dup: 3")


# Harmonize factor ordering with line-plot script
box_df <- box_df %>%
  mutate(
    Method = factor(Method, levels = c("apro3", "wqfm-gdl"), labels = c(
      "Astral-Pro3", "wQFM-GDL-T"
    )),
    loss = factor(loss, levels = c("0.1", "1")),
    dup = factor(dup, levels = c("0.25", "1", "3"),
                 labels = c("dup: 0.25", "dup: 1", "dup: 3")),
    gt = factor(gt, levels = c("250", "500", "1000"),
                labels = c("Input: 250 gt", "Input: 500 gt", "Input: 1000 gt")),
    ils = factor(ils, levels = c("25", "70"),
                 labels = c("ILS: 25%", "ILS: 70%")),
    taxa = factor(taxa, levels = c("200", "500"),
                  labels = c("Taxa: 200", "Taxa: 500"))
  )

box_df_filtered <- box_df %>%
  filter(taxa %in% selected_taxa,
         ils %in% selected_ils,
         dup %in% selected_dup)

# Box-plot visualization
p_box <- ggplot(box_df_filtered, aes(x = loss, y = Error, fill = Method)) +
  geom_boxplot(width = 0.6, position = position_dodge(width = 0.7), outlier.size = 0.8) +
  facet_grid(gt ~ dup, scales = "free_x", space = "free_x") +
  scale_fill_brewer(palette = "Set2", name = "") +
  scale_y_continuous(labels = scales::percent) +
  labs(
    x = "Loss",
    y = "Species tree error (NRF)"
  ) +
  theme_classic() +
  theme(
    legend.position = "bottom",
    panel.border = element_rect(fill = NA, size = 1)
  )

print(p_box)
