library(ggplot2)
library(dplyr)
library(readr)

# 1. Read your merged CSV file
df <- read_csv("merged_for_plot.csv")
# methods <- c("wQFM-G-Q", "wQFM-G-T", "APro3", "Species-rax", "DupLoss2")
methods <- c("wQFM-G-Q", "wQFM-G-T", "APro3", "Species-rax")

# 2. Filter for specific dup rates and prepare data
df <- df %>%
  filter(DupRate %in% c("0", "1", "5")) %>%
  filter(Method %in% methods) %>%
  mutate(
    Method = factor(Method, levels = methods),
    DupRate = factor(DupRate, levels = c("0", "1", "5")),
    InputType = factor(InputType, levels = c("Input: Est. (100bp)",
                                             "Input: Est. (500bp)",
                                             "Input: true")),
    ILS = as.numeric(ILS)
  )

# 3. Summarize across replicates → mean + standard error
summary_df <- df %>%
  group_by(Method, DupRate, LossRate, ILS, InputType) %>%
  summarise(
    mean_error = mean(Error, na.rm = TRUE),
    se_error = sd(Error, na.rm = TRUE) / sqrt(n()),
    .groups = "drop"
  )

# 4. Filter for LossRate: 0 when Dup=0, else 1
summary_df <- summary_df %>%
  filter((DupRate == "0" & LossRate == 0) | (DupRate %in% c("1", "5") & LossRate == 1))

# 5. Plot
p <- ggplot(summary_df, aes(x = ILS, y = mean_error, color = Method, group = Method)) +
  geom_line() +
  geom_errorbar(aes(ymin = mean_error - se_error,
                    ymax = mean_error + se_error), width = 2) +
  geom_point(size = 1) +
  facet_grid(InputType ~ DupRate,
             labeller = labeller(DupRate = function(x) paste("Dup:", x))) +
  scale_color_brewer(palette = "Set2", name = "") +
  scale_y_continuous(labels = scales::percent) +
  labs(x = "ILS level (RF%)", y = "Species tree error (NRF)") +
  theme_classic() +
  theme(
    legend.position = "bottom",
    panel.border = element_rect(fill = NA, size = 1)
  )

print(p)
ggsave("./plots/plot_ils_apro_wqfm_sprax.pdf", plot = p)
