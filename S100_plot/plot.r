library(ggplot2)
library(dplyr)
library(readr)

# Load data (must include columns: Method, DupRate, InputType, SeqLen, Error, Replicate)
df <- read_csv("merged_for_plot.csv")

# Summarize replicates to mean ± SE
df_summary <- df %>%
  group_by(Method, SeqLen, DupRate, InputType) %>%
  summarise(
    Mean = mean(Error),
    SE = sd(Error) / sqrt(n()),
    .groups = "drop"
  )

# Factor ordering for nicer layout
df_summary <- df_summary %>%
  mutate(
    Method = factor(Method, levels = c("Apro", "wqfm-gdl", "wqfm2020")),
    DupRate = factor(DupRate, levels = c("0", "0.2", "1", "2", "5")),
    SeqLen = factor(SeqLen, levels = c("25", "50", "100", "250"),
                    labels = c("Seq: 25 bp", "Seq: 50 bp", "Seq: 100 bp", "Seq: 250 bp")),
    InputType = factor(InputType, levels = c("Psize 10000000", "Psize 50000000"),
                       labels = c("Input: Psize 10000000", "Input: Psize 50000000"))
  )

# Plot
p <- ggplot(df_summary, aes(x = DupRate, y = Mean, color = Method, group = Method)) +
  geom_line(size = 0.7) +
  geom_point(size = 2) +
  geom_errorbar(aes(ymin = Mean - SE, ymax = Mean + SE), width = 0.15) +
  facet_grid(InputType ~ SeqLen, switch = "y") +
  scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  labs(
    x = "Duplication Rate",
    y = "Species tree error (NRF)"
  ) +
  theme_bw() +
  theme(
    strip.background = element_rect(color = "black", fill = "white"),
    strip.text = element_text(size = 11, face = "bold"),
    axis.title = element_text(size = 13),
    axis.text = element_text(size = 10),
    legend.position = "right",
    panel.border = element_rect(color = "black"),
    panel.spacing = unit(1, "lines"),
    strip.placement = "outside"
  )

print(p)
