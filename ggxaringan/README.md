ggxaringan
================

This folder contains the files used to create [this short screen recording](https://youtu.be/l9yUGFelT5c) demonstrating how I use the infinite_moon_reader() function from the [xaringan](https://github.com/yihui/xaringan) package to achieve continuous integration while creating and customizing a ggplot2 chart.

When refining a chart in R, I first create a xaringan _presentation slide_ of that chart, and then call `xaringan::infinite_moon_reader()` to achieve continuous integration while I customize it. Every time I save the .Rmd file with `Command + S`, the chart is automatically rendered in the viewer.

Some of the benefits I've found from this approach include:

- Immediate updating of the chart as I edit it.
- Using the chunk settings `fig.height` and `fig.width`, I can preview what dimension settings I should use to save the chart.
- I can quickly create multiple charts by just adding another "slide" with `---`. Once created, I can scroll through the slides to compare my charts. This is particularly helpful for comparing multiple versions of the same plot, e.g. with a different color scheme.
- A .png file of the plot is automatically created in the `_files` -> `figure-html` folder, so I don't need to call `ggsave()`.
- If I name the chunk, the saved .png file takes that chunk name (+ .png).
- Helps with de-bugging as the slide won't render if there's an error.
