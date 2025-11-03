library(ggplot2)
library(dplyr)
library(readr)

# Load data (must include columns: Method, loss, gt, dup, Error, Replicate)
df <- read_csv("merged_for_plot.csv")

selected_taxa <- c("Taxa: 500")    # or c("Taxa: 200", "Taxa: 500")
selected_ils <- c("ILS: 70%")
selected_dup <- c("dup: 0.25", "dup: 1", "dup: 3")

# Factor ordering for nicer layout
df <- df %>%
  mutate(
    Method = factor(Method, levels = c("apro3", "wqfm-gdl"), labels = c(
      "Astral-Pro3", "wQFM-GDL-T"
    )),
    loss = factor(loss, levels = c("0.1","1")),
    dup = factor(dup, levels = c("0.25", "1", "3"),
                    labels = c("dup: 0.25", "dup: 1", "dup: 3")),
    gt = factor(gt, levels = c("250", "500", "1000"),
                       labels = c("Input: 250 gt", "Input: 500 gt", "Input: 1000 gt")),
    ils = factor(ils, levels = c("25", "70"),
                       labels = c("ILS: 25%", "ILS: 70%")),
    taxa = factor(taxa, levels = c("200", "500"),
                       labels = c("Taxa: 200", "Taxa: 500"))
    
    # taxa = factor(taxa, levels = c("200"),
    #                    labels = c("Taxa: 200"))
  )

df_filtered <- df %>%
  filter(taxa %in% selected_taxa,
         ils %in% selected_ils,
         dup %in% selected_dup)

# Plot
p <- ggplot(df_filtered, aes(x = loss, y = Error, color = Method, group = Method)) +
  stat_summary(geom = "line", fun.data = mean_se) +
  stat_summary(geom = "errorbar", fun.data = mean_se, width = 0.22) +
  stat_summary(geom = "point", fun.data = mean_se, size = 1) +
  facet_grid(gt ~ dup, scales = "free_x", space = "free_x") +
  scale_color_brewer(palette = "Set2", name = "") +
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

print(p)
