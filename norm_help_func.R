norm_help <- function(percentile = NULL,
                      z = NULL,
                      quantile = NULL,
                      mean = 0,
                      sd = 1,
                      title = "Normal Distribution",
                      colour = "#00BFFF",
                      save = FALSE,
                      caption = FALSE,
                      units = "cm", 
                      width = 40, 
                      height = 25,
                      image = "png") {
  # Load/Install Packages
  if (!require("ggplot2")) install.packages("ggplot2")
  library("ggplot2")
  if (!require("ggrepel")) install.packages("ggrepel")
  library("ggrepel")

  # Function Arguments
  cent <- mean
  spread <- sd
  
  args <- c(!is.null(percentile), !is.null(z), !is.null(quantile))
  if (sum(args) > 1) {
    stop("Invalid input: \nPlease provide only one of the following — 'percentile', 'z', or 'quantile'. \nThese options are mutually exclusive and cannot be combined.")
  }

  if (is.numeric(percentile)) {
    perc <- percentile
    z <- qnorm(perc / 100, mean = 0, sd = 1)
    quant <- qnorm(perc / 100, mean = cent, sd = spread)
  } else if (is.numeric(z)) {
    perc <- pnorm(z, mean = 0, sd = 1) * 100
    quant <- qnorm(perc / 100, mean = cent, sd = spread)
  } else if (is.numeric(quantile)) {
    quant <- quantile
    perc <- pnorm(quantile, mean = cent, sd = spread) * 100
    z <- qnorm(perc / 100, mean = 0, sd = 1)
  } else {
    perc <- .0001
    z <- qnorm(perc / 100, mean = 0, sd = 1)
    quant <- qnorm(perc / 100, mean = cent, sd = spread)
  }

  # Main Distribution
  x <- seq((cent - spread * 3.5), (cent + spread * 3.5), by = 0.01)

  df <- data.frame(
    x = x,
    y = dnorm(x,
      mean = cent,
      sd = spread
    )
  )

  # Percent Segments
  df_seg <- data.frame(
    segs = seq(-3, 3, 1)
  )

  df_seg$seg_loc <- cent + spread * df_seg$segs
  df_seg$y_seg <- dnorm(df_seg$seg_loc,
    mean = cent,
    sd = spread
  )

  # Text
  # Percentages
  text <- c(
    rev(round(pnorm(seq(1, 4, 1)) * 100 - pnorm(seq(0, 3, 1)) * 100, 1)),
    round(pnorm(seq(1, 4, 1)) * 100 - pnorm(seq(0, 3, 1)) * 100, 1)
  )

  # DataFrame of coords
  text_df <- data.frame(text,
    x = seq(cent - 3.5 * spread,
      cent + 3.5 * spread,
      length.out = 8
    ),
    y = dnorm(
      seq(cent - 3.5 * spread,
        cent + 3.5 * spread,
        length.out = 8
      ),
      mean = cent,
      sd = spread
    )
  )

  # Height Adjustment
  text_df$y <- text_df$y - text_df$y / 2
  text_df$y[c(1:2, 7:8)] <- text_df$y[c(1:2, 7:8)] +
    text_df$y[c(1:2, 7:8)] *
      c(60, 4, 4, 60)


  # Plot
  x_nudge <- ifelse(z > 0, 1.25 * spread, (-1.25) * spread)
  caption_txt <- paste("\n\n\nPercentile: A point in a distribution below which a ",
    "specified percentage of the values fall.",
    "\n        Can be conceptualized as 'area under the curve calculated from left to right. ",
    "\n        -E.g., The 50th percentile equals 50% of the area under the curve shaded.",
    "\n\nz-score: Distance from the mean (\U00B5) in standard deviations (\U03C3). ",
    "\n        Note: each segment of the distribution represents 1 standard deviation.",
    "\n\nQuantile: A location on the distributions x-axis. ",
    "\n        -The z-score is a type of quantile. ",
    "\n        -When \U00B5 = 0 and \U03C3 = 1, the x-axis is z-scores.",
    sep = ""
  )
  subtitle <- paste("\U00B5 = ", round(cent, 2),
    ", \U03C3 = ", round(spread, 2),
    sep = ""
  )

  plot <- ggplot(df, aes(x = x, y = y)) +

    # Percentage Labels
    geom_text(
      data = text_df, aes(x = x, y = y),
      label = paste(text, "%", sep = ""),
      colour = "#696969",
      size = 6
    ) +

    # Percentile shading
    geom_ribbon(
      data = subset(df, x < quant),
      aes(ymax = y, ymin = 0),
      fill = colour,
      colour = NA,
      alpha = .35
    ) +

    # Distribution
    stat_function(
      fun = dnorm, args = c(mean = cent, sd = spread),
      linewidth = 1
    ) +

    # Percentage Guide Segments
    geom_segment(data = df_seg, aes(
      x = seg_loc,
      xend = seg_loc,
      y = 0,
      yend = y_seg
    )) +

    # Requested Point
    {
      if (perc > 0.01 & perc <= 99.99) {
        geom_label_repel(
          data = data.frame(
            x = quant,
            y = dnorm(quant,
              mean = cent,
              sd = spread
            ),
            lab = paste("Percentile = ",
              round(perc, 2),
              "\nz = ",
              round(z, 2),
              "\nQuantile = ",
              round(quant, 2),
              sep = ""
            )
          ),
          aes(label = lab),
          box.padding = 0.35,
          point.padding = 1,
          segment.color = "black",
          nudge_x = x_nudge,
          segment.angle = 20,
          segment.size = 0.75,
          size = 6
        )
      }
    } +
    {
      if (perc > 0.01 & perc <= 99.99) {
        geom_segment(
          x = quant,
          y = 0,
          xend = quant,
          yend = dnorm(quant, mean = cent, sd = spread),
          colour = "red",
          linewidth = 1
        )
      }
    } +
    {
      if (perc > 0.01 & perc <= 99.99) {
        annotate(
          geom = "point",
          x = quant,
          y = dnorm(quant,
            mean = cent,
            sd = spread),
          colour = "red",
          size = 5
        )
      }
    } +

    # Axis
    scale_x_continuous(breaks = round(df_seg$seg_loc, 2)) +
    labs(
      x = "Quantile\n(i.e., x-value)",
      y = "Density",
      title = title,
      subtitle = subtitle,
      caption = ifelse(caption == TRUE, caption_txt, "")
    ) +
    theme_classic() +
    theme(
      plot.title = element_text(hjust = 0.5, size = 24, face = "bold"),
      plot.subtitle = element_text(hjust = 0.5, size = 18, face = "bold"),
      plot.caption = element_text(hjust = 0, size = 14),
      axis.text = element_text(colour = "black", size = 18),
      axis.title = element_text(colour = "black", size = 20)
    )

  print(plot)

  if (save == TRUE) {
    filename <- paste0(round(perc), "th Percentile Plot.", image)
    ggsave(filename, dpi = 400, units = units, width = width, height = height)
    message(paste("File saved as '", filename, "'", sep = ""))
  }
}
