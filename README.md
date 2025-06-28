# R Function for Visualizing $z$-scores, Quantiles, and Percentiles

## Description
A simple R function to illustrate the distinction between percentiles, z-scores, and quantiles in a normal distribution.

## Example usage and output

```r
norm_help(percentile = 11,
          z = NULL, 
          quantile = NULL,
          mean = 666,
          sd = 13,
          title = "Normal Distribution",
          colour = "#00BFFF",
          save = FALSE,
          caption = TRUE,
          width = 40,
          height = 25,
          units = "cm",
          image = "png"
)
```

<img title="11th Percentile Plot.png" src="11th Percentile Plot.png">

## Loading the function
To load the function in R, run the following code:
`source("https://raw.githubusercontent.com/jpisklak/Norm_Dist_Help/main/norm_help_func.R")`

## Arguments

`percentile` 
- A numeric value between 0 and 100 indicating the percentile to display.

`z`
- A numeric $z$-score to display on the plot (pronounced "zed-score").

`quantile`
- x-axis point-value displayed on plot.

`mean`, `sd`

- Numeric values specifying the mean and standard deviation of the normal distribution. Defaults are `mean = 0` and `sd = 1`.

`title`

- A character string specifying the plot title.

`colour`

- A character string indicating the fill color for the shaded region (e.g., `"steelblue"` or `"#B22222"`).

`save`

- Logical (`TRUE` or `FALSE`). If TRUE, the plot is saved to file. Default is `FALSE`.

`caption`

- Logical (`TRUE` or `FALSE`). If `TRUE`, a caption explaining the interpretation is added to the plot. Default is `FALSE`.

`width`, `height`

- Numeric values specifying the dimensions of the saved image.

`units`

- A character string specifying the units of the saved image's dimensions. Options include `"in"`, `"cm"`, `"mm"`, and `"px"`.

`image`

- A character string specifying the image type to be saved. Options include `"png"` (default), `"eps"`, `"ps"`, `"pdf"`, `"jpeg"`, `"tiff"`, `"png"`, `"bmp"`, `"svg"`.


## Details

Specify only one of `percentile`, `z`, or `quantile`. These arguments are mutually exclusive — if more than one is provided, the function default to the first .

For raster graphics, plot saves at a resolution of 400 dpi.

The following CRAN packages are necessary to run this function and will be automatically installed and loaded when run:

- **ggplot2**:
  -   H. Wickham. ggplot2: Elegant Graphics for Data Analysis.
  Springer-Verlag New York, 2016. 
  
- **ggrepel**:
  - Slowikowski, K. (2024). *ggrepel: Automatically position non-overlapping text labels with ggplot2* (R package version 0.9.6). https://CRAN.R-project.org/package=ggrepel
  
## Citation

If you use this tool in your teaching, writing, or research, please cite it as follows:

Pisklak, J. M. (2025). *R Function for Visualizing $z$-scores, Quantiles, and Percentiles* [R code]. GitHub. https://github.com/jpisklak/Norm_Dist_Help

```bibtex
@online{ ,
  author       = {Pisklak, Jeffrey M.},
  title        = {R Function for Visualizing Z-scores, Quantiles, and Percentiles},
  year         = {2025},
  organization = {GitHub},
  note         = {R code},
  url          = {https://github.com/jpisklak/Norm_Dist_Help}
}
```