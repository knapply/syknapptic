---
title: 'Tidyverse: Getting Your Feet Wet'
draft: false
author: Brendan Knapp
date: '2018-03-15'
slug: tidyverse-getting-your-feet-wet
categories:
  - data carpentry
tags:
  - tidyverse
  - ggplot
  - dplyr
  - tidyr
thumbnailImagePosition: left
thumbnailImage: http://res.cloudinary.com/syknapptic/image/upload/v1521124488/tidyverse_awesome_dukagq.png
metaAlignment: center
coverMeta: out
summary: A (hopefully) gentle introduction to R's tidyverse that I as a primer for a short series of workshops I taught.
---



I recently had the opportunity to teach some tidyverse code to colleagues and classmates in a series of workshops. Some had already dabbled in R or other languages, but it was the first time that the majority of participants had written a single line of code.

In preparation for this workshop series, I found a lot of inspiration in [Michael Levy's presentation on teaching R](http://michaellevy.name/blog/useR-talk-on-teaching-R/), which itself echoes principles preached by other R advocates. 

One of my biggest takeaways is that __live coding works__.

Writing code in real time shows every single step we make from opening the IDE, to reshaping the data, to debugging inevitable errors, to rendering a final report.

Within a few short weeks of learning to code, it is surprising how many tiny steps become automatic and taken for granted. Tack on a couple more months and newcomers will think you're speaking in an entirely different language when you're explaining something requiring context they simply haven't yet encountered. Add a few years and... yeesh.

Something that frustrated me when I first started is that code explanations often seem to be written in such a way that dismisses how difficult the basics can be. I'm half-convinced that for some folks, the trauma was so great that they have simply blocked it from memory.

Live coding enforces a maximum speed in moving through exercises, which not only gives students more time to digest what you're doing. It also provides more opportunity to for them to ask questions on details you might find trivial, but only because you _already_ suffered through them.

I also think that the benefits of live coding go both ways. I found myself answering questions that framed things in ways that I had not even considered. Additionally, I have a better sense now of which concepts need to be covered in more detail, as they weren't necessarily as inuitive for others as they were for me. On the flip-side, concepts that I remember struggling with may not be difficult at all for others to understand.

I'll cut the bloggyness of this blog post here, and get to the meat of what we covered. Before I forget, the title image came originally from [R Memes for Statistical Fiends](https://www.facebook.com/Rmemes0/). If you're reading this, you'll likely find their memes of satisfactory dankness.


```r
# install.packages("devtools")
# install.packages("tidyverse")
library(tidyverse)
# loads {ggplot2}, {tibble}, {tidyr}, {readr}, {purrr}, {dplyr}, {stringr}, and {forcats}

# install.packages("gapminder")
library(gapminder)
# loads the gapminder data set


# install.packages("kableExtra")
library(knitr)
library(kableExtra)
# just to prettify printed tables when knitting

# library(scales)
```


# Workflow

<img src="workflow_2.png" width="468" style="display: block; margin: auto;" />


<img src="workflow.png" width="827" style="display: block; margin: auto;" />

<img src="tidyverse_expanded.png" width="480" style="display: block; margin: auto;" />


# Resources Up Front

## Data Carpentry

[![](https://raw.githubusercontent.com/tidyverse/tidyr/master/man/figures/logo.png)](http://tidyr.tidyverse.org/) [![](https://raw.githubusercontent.com/tidyverse/dplyr/master/man/figures/logo.png)](http://dplyr.tidyverse.org/)

* [Cheat Sheet](https://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf)

<img src="data_carpentry.png" width="1206" style="display: block; margin: auto;" />


## Plotting

[![](https://raw.githubusercontent.com/tidyverse/ggplot2/master/man/figures/logo.png)](http://ggplot2.tidyverse.org/)

* [Cheat Sheet](https://www.rstudio.com/wp-content/uploads/2015/03/ggplot2-cheatsheet.pdf)

<img src="ggplot_cheat_sheet.png" width="1148" style="display: block; margin: auto;" />


* [R Graph Catalog](http://shiny.stat.ubc.ca/r-graph-catalog/)

<img src="r_graph_catalog.png" width="1908" style="display: block; margin: auto;" />


<br><br><br><br>

# Gapminder Data

In the following exercises, `gm.data.frame` will be used to demonstrate actions that use `{base}` R methods for `data.frame` operations while `gm_df` will be used to to demonstrate `{tidyverse}` methods for `tibble` operations.


```r
gm.data.frame <- as.data.frame(gapminder)

gm_df <- gapminder
```


# `tibble`s


```r
class(gm.data.frame)
```

```
## [1] "data.frame"
```

```r
class(gm_df)
```

```
## [1] "tbl_df"     "tbl"        "data.frame"
```

`tibble`s are opinionated `data.frame`s that keep everything that is helpful about `data.frames` changes what is unhelpful, and adds methods that makes thems even more useful.

Printing `gm.data.frame` dumps the whole data set to the console, typically requiring `head()` to limit the output.

### Printing


```r
head(gm.data.frame)
```

```
##       country continent year lifeExp      pop gdpPercap
## 1 Afghanistan      Asia 1952  28.801  8425333  779.4453
## 2 Afghanistan      Asia 1957  30.332  9240934  820.8530
## 3 Afghanistan      Asia 1962  31.997 10267083  853.1007
## 4 Afghanistan      Asia 1967  34.020 11537966  836.1971
## 5 Afghanistan      Asia 1972  36.088 13079460  739.9811
## 6 Afghanistan      Asia 1977  38.438 14880372  786.1134
```


Printing the `gm_df` provides the dimensions, data type of each column, and only prints the first 10 rows.


```r
gm_df
```

```
## # A tibble: 1,704 x 6
##    country     continent  year lifeExp      pop gdpPercap
##    <fct>       <fct>     <int>   <dbl>    <int>     <dbl>
##  1 Afghanistan Asia       1952    28.8  8425333       779
##  2 Afghanistan Asia       1957    30.3  9240934       821
##  3 Afghanistan Asia       1962    32.0 10267083       853
##  4 Afghanistan Asia       1967    34.0 11537966       836
##  5 Afghanistan Asia       1972    36.1 13079460       740
##  6 Afghanistan Asia       1977    38.4 14880372       786
##  7 Afghanistan Asia       1982    39.9 12881816       978
##  8 Afghanistan Asia       1987    40.8 13867957       852
##  9 Afghanistan Asia       1992    41.7 16317921       649
## 10 Afghanistan Asia       1997    41.8 22227415       635
## # ... with 1,694 more rows
```


# `%>%`

<img src="magrittr.png" width="90" style="display: block; margin: auto;" />


The pipe (`%>%`) is used to chain operations together. Underneath the hood, it's taking the value on the left-hand side of `%>%` and using it as the first argument of the function on the right-hand side of `%>%`.

For example, these 2 lines are doing the exact same thing.


```r
head(gm_df)
```

```
## # A tibble: 6 x 6
##   country     continent  year lifeExp      pop gdpPercap
##   <fct>       <fct>     <int>   <dbl>    <int>     <dbl>
## 1 Afghanistan Asia       1952    28.8  8425333       779
## 2 Afghanistan Asia       1957    30.3  9240934       821
## 3 Afghanistan Asia       1962    32.0 10267083       853
## 4 Afghanistan Asia       1967    34.0 11537966       836
## 5 Afghanistan Asia       1972    36.1 13079460       740
## 6 Afghanistan Asia       1977    38.4 14880372       786
```

```r
gm_df %>% head()
```

```
## # A tibble: 6 x 6
##   country     continent  year lifeExp      pop gdpPercap
##   <fct>       <fct>     <int>   <dbl>    <int>     <dbl>
## 1 Afghanistan Asia       1952    28.8  8425333       779
## 2 Afghanistan Asia       1957    30.3  9240934       821
## 3 Afghanistan Asia       1962    32.0 10267083       853
## 4 Afghanistan Asia       1967    34.0 11537966       836
## 5 Afghanistan Asia       1972    36.1 13079460       740
## 6 Afghanistan Asia       1977    38.4 14880372       786
```

For simple operations involving 1 function, `%>%` is only slightly beneficial in that it improves readability as the flow of operations go from left to right.

`%>%` become truly useful when you need to perform multiple operations in succession.

As an arbitrary example, let's say that we want to select the `head()` (first 6 rows) of `gm.data.frame` and convert it to a `tibble`.

Without `%>%`, we can do this in a few ways.

1. Use intermediate variables.
    + get `gm.data.frame`'s `head()` and assign it to `no_pipe_1`
    + convert `no_pipe_1` to a `tibble` with `as_tibble()` and assign it to `no_pipe_2`


```r
no_pipe_1 <- head(gm.data.frame)

no_pipe_2 <- as_tibble(no_pipe_1)

no_pipe_2
```

```
## # A tibble: 6 x 6
##   country     continent  year lifeExp      pop gdpPercap
## * <fct>       <fct>     <int>   <dbl>    <int>     <dbl>
## 1 Afghanistan Asia       1952    28.8  8425333       779
## 2 Afghanistan Asia       1957    30.3  9240934       821
## 3 Afghanistan Asia       1962    32.0 10267083       853
## 4 Afghanistan Asia       1967    34.0 11537966       836
## 5 Afghanistan Asia       1972    36.1 13079460       740
## 6 Afghanistan Asia       1977    38.4 14880372       786
```

2. Nest `head()` inside of `as_tibble()`.


```r
as_tibble(head(gm.data.frame))
```

```
## # A tibble: 6 x 6
##   country     continent  year lifeExp      pop gdpPercap
## * <fct>       <fct>     <int>   <dbl>    <int>     <dbl>
## 1 Afghanistan Asia       1952    28.8  8425333       779
## 2 Afghanistan Asia       1957    30.3  9240934       821
## 3 Afghanistan Asia       1962    32.0 10267083       853
## 4 Afghanistan Asia       1967    34.0 11537966       836
## 5 Afghanistan Asia       1972    36.1 13079460       740
## 6 Afghanistan Asia       1977    38.4 14880372       786
```

With `%>%`, we can chain these actions together in the order in which they occur, which is also the way we read English.

* Here, we do the same thing by:
    + taking `gm_df`
    + piping it to `head()` (keeping the top 6 rows)
    + piping it to `as_tibble()` (converting it to a `tibble` data frame)


```r
gm_df %>% head() %>% as_tibble()
```

```
## # A tibble: 6 x 6
##   country     continent  year lifeExp      pop gdpPercap
##   <fct>       <fct>     <int>   <dbl>    <int>     <dbl>
## 1 Afghanistan Asia       1952    28.8  8425333       779
## 2 Afghanistan Asia       1957    30.3  9240934       821
## 3 Afghanistan Asia       1962    32.0 10267083       853
## 4 Afghanistan Asia       1967    34.0 11537966       836
## 5 Afghanistan Asia       1972    36.1 13079460       740
## 6 Afghanistan Asia       1977    38.4 14880372       786
```

In practice, it's usually best to place each of the functions on a separate line as it  facilitates debugging and further improves readability.


```r
gm_df %>%
  as_tibble() %>%
  head()
```

```
## # A tibble: 6 x 6
##   country     continent  year lifeExp      pop gdpPercap
##   <fct>       <fct>     <int>   <dbl>    <int>     <dbl>
## 1 Afghanistan Asia       1952    28.8  8425333       779
## 2 Afghanistan Asia       1957    30.3  9240934       821
## 3 Afghanistan Asia       1962    32.0 10267083       853
## 4 Afghanistan Asia       1967    34.0 11537966       836
## 5 Afghanistan Asia       1972    36.1 13079460       740
## 6 Afghanistan Asia       1977    38.4 14880372       786
```

From here on, you'll notice `prettify()`. This is only being used to print tables in a clean format when the document is `knit()`ted. 

`data.frame`s will print a default maximum of 3 rows while `tibble`s will print a default maximum of 10 rows.


```r
prettify <- function(df, n = NULL, cols_changed = NULL, rows_changed = NULL){
  if(is.null(n)) n <- ifelse(is.tibble(df), 10, 3)
  pretty_df <- df %>%
    head(n) %>%
    kable(format = "html") %>%
    kable_styling(bootstrap_options = c("striped", "bordered", "condensed",
                                        "hover", "responsive"),
                  full_width = FALSE)
  
  if(!is.null(cols_changed)){
    pretty_df <- pretty_df %>%
      column_spec(cols_changed, bold = T, color = "black", background = "#C8FAE3")
  }
  
  if(!is.null(rows_changed)){
    pretty_df <- pretty_df %>%
      row_spec(rows_changed, bold = T, color = "black", background = "#C8FAE3")
  }
  
  return(pretty_df)
}
```


```r
gm.data.frame %>%
  prettify()
```

<table class="table table-striped table-bordered table-condensed table-hover table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> country </th>
   <th style="text-align:left;"> continent </th>
   <th style="text-align:right;"> year </th>
   <th style="text-align:right;"> lifeExp </th>
   <th style="text-align:right;"> pop </th>
   <th style="text-align:right;"> gdpPercap </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1952 </td>
   <td style="text-align:right;"> 28.801 </td>
   <td style="text-align:right;"> 8425333 </td>
   <td style="text-align:right;"> 779.4453 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1957 </td>
   <td style="text-align:right;"> 30.332 </td>
   <td style="text-align:right;"> 9240934 </td>
   <td style="text-align:right;"> 820.8530 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1962 </td>
   <td style="text-align:right;"> 31.997 </td>
   <td style="text-align:right;"> 10267083 </td>
   <td style="text-align:right;"> 853.1007 </td>
  </tr>
</tbody>
</table>

```r
gm_df %>%
  prettify()
```

<table class="table table-striped table-bordered table-condensed table-hover table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> country </th>
   <th style="text-align:left;"> continent </th>
   <th style="text-align:right;"> year </th>
   <th style="text-align:right;"> lifeExp </th>
   <th style="text-align:right;"> pop </th>
   <th style="text-align:right;"> gdpPercap </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1952 </td>
   <td style="text-align:right;"> 28.801 </td>
   <td style="text-align:right;"> 8425333 </td>
   <td style="text-align:right;"> 779.4453 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1957 </td>
   <td style="text-align:right;"> 30.332 </td>
   <td style="text-align:right;"> 9240934 </td>
   <td style="text-align:right;"> 820.8530 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1962 </td>
   <td style="text-align:right;"> 31.997 </td>
   <td style="text-align:right;"> 10267083 </td>
   <td style="text-align:right;"> 853.1007 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1967 </td>
   <td style="text-align:right;"> 34.020 </td>
   <td style="text-align:right;"> 11537966 </td>
   <td style="text-align:right;"> 836.1971 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1972 </td>
   <td style="text-align:right;"> 36.088 </td>
   <td style="text-align:right;"> 13079460 </td>
   <td style="text-align:right;"> 739.9811 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1977 </td>
   <td style="text-align:right;"> 38.438 </td>
   <td style="text-align:right;"> 14880372 </td>
   <td style="text-align:right;"> 786.1134 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1982 </td>
   <td style="text-align:right;"> 39.854 </td>
   <td style="text-align:right;"> 12881816 </td>
   <td style="text-align:right;"> 978.0114 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1987 </td>
   <td style="text-align:right;"> 40.822 </td>
   <td style="text-align:right;"> 13867957 </td>
   <td style="text-align:right;"> 852.3959 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1992 </td>
   <td style="text-align:right;"> 41.674 </td>
   <td style="text-align:right;"> 16317921 </td>
   <td style="text-align:right;"> 649.3414 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1997 </td>
   <td style="text-align:right;"> 41.763 </td>
   <td style="text-align:right;"> 22227415 </td>
   <td style="text-align:right;"> 635.3414 </td>
  </tr>
</tbody>
</table>

# Sample Data

You'll also see a toy data set for the introductory examples that start each section.


```r
sample_countries <- c("Tunisia", "Nicaragua", "Singapore", "Hungary", "New Zealand",
                      "Nigeria", "Brazil", "Sri Lanka", "Ireland", "Australia")
  
sample_df <- gm_df %>%
  filter(year == 2007,
         country %in% sample_countries)

sample_df %>%     
  prettify()
```

<table class="table table-striped table-bordered table-condensed table-hover table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> country </th>
   <th style="text-align:left;"> continent </th>
   <th style="text-align:right;"> year </th>
   <th style="text-align:right;"> lifeExp </th>
   <th style="text-align:right;"> pop </th>
   <th style="text-align:right;"> gdpPercap </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Australia </td>
   <td style="text-align:left;"> Oceania </td>
   <td style="text-align:right;"> 2007 </td>
   <td style="text-align:right;"> 81.235 </td>
   <td style="text-align:right;"> 20434176 </td>
   <td style="text-align:right;"> 34435.367 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Brazil </td>
   <td style="text-align:left;"> Americas </td>
   <td style="text-align:right;"> 2007 </td>
   <td style="text-align:right;"> 72.390 </td>
   <td style="text-align:right;"> 190010647 </td>
   <td style="text-align:right;"> 9065.801 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Hungary </td>
   <td style="text-align:left;"> Europe </td>
   <td style="text-align:right;"> 2007 </td>
   <td style="text-align:right;"> 73.338 </td>
   <td style="text-align:right;"> 9956108 </td>
   <td style="text-align:right;"> 18008.944 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Ireland </td>
   <td style="text-align:left;"> Europe </td>
   <td style="text-align:right;"> 2007 </td>
   <td style="text-align:right;"> 78.885 </td>
   <td style="text-align:right;"> 4109086 </td>
   <td style="text-align:right;"> 40675.996 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> New Zealand </td>
   <td style="text-align:left;"> Oceania </td>
   <td style="text-align:right;"> 2007 </td>
   <td style="text-align:right;"> 80.204 </td>
   <td style="text-align:right;"> 4115771 </td>
   <td style="text-align:right;"> 25185.009 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Nicaragua </td>
   <td style="text-align:left;"> Americas </td>
   <td style="text-align:right;"> 2007 </td>
   <td style="text-align:right;"> 72.899 </td>
   <td style="text-align:right;"> 5675356 </td>
   <td style="text-align:right;"> 2749.321 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Nigeria </td>
   <td style="text-align:left;"> Africa </td>
   <td style="text-align:right;"> 2007 </td>
   <td style="text-align:right;"> 46.859 </td>
   <td style="text-align:right;"> 135031164 </td>
   <td style="text-align:right;"> 2013.977 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Singapore </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 2007 </td>
   <td style="text-align:right;"> 79.972 </td>
   <td style="text-align:right;"> 4553009 </td>
   <td style="text-align:right;"> 47143.180 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Sri Lanka </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 2007 </td>
   <td style="text-align:right;"> 72.396 </td>
   <td style="text-align:right;"> 20378239 </td>
   <td style="text-align:right;"> 3970.095 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Tunisia </td>
   <td style="text-align:left;"> Africa </td>
   <td style="text-align:right;"> 2007 </td>
   <td style="text-align:right;"> 73.923 </td>
   <td style="text-align:right;"> 10276158 </td>
   <td style="text-align:right;"> 7092.923 </td>
  </tr>
</tbody>
</table>


# "Tidy" Data

<img src="tidy_data.png" width="490" style="display: block; margin: auto;" />

<img src="tidy_data_2.png" width="960" style="display: block; margin: auto;" />

<img src="messy_tidy.png" width="480" style="display: block; margin: auto;" />

With `tibble`s, `%>%`, and the concept of tidy data covered, let's take a dive.

# `{dplyr}`

<img src="dplyr.png" width="60" style="display: block; margin: auto;" />


`{dplyr}` provides a grammar of data manipulation and a set of verb functions that solve most common data carpentry challenges in a consistent fashion.

* `glimpse()`
* `select()`
* `filter()`
* `arrange()`
* `mutate()`
* `summarize()`
* `group_by()`

# Taking a `glimpse()`

In addition to the `summary()`, `dim()`ensions, and `str()`ucture functions that can be used to inspect data, you can now use `{dplyr}`'s `glimpse()`.


```r
summary(gm.data.frame)
```

```
##         country        continent        year         lifeExp     
##  Afghanistan:  12   Africa  :624   Min.   :1952   Min.   :23.60  
##  Albania    :  12   Americas:300   1st Qu.:1966   1st Qu.:48.20  
##  Algeria    :  12   Asia    :396   Median :1980   Median :60.71  
##  Angola     :  12   Europe  :360   Mean   :1980   Mean   :59.47  
##  Argentina  :  12   Oceania : 24   3rd Qu.:1993   3rd Qu.:70.85  
##  Australia  :  12                  Max.   :2007   Max.   :82.60  
##  (Other)    :1632                                                
##       pop              gdpPercap       
##  Min.   :6.001e+04   Min.   :   241.2  
##  1st Qu.:2.794e+06   1st Qu.:  1202.1  
##  Median :7.024e+06   Median :  3531.8  
##  Mean   :2.960e+07   Mean   :  7215.3  
##  3rd Qu.:1.959e+07   3rd Qu.:  9325.5  
##  Max.   :1.319e+09   Max.   :113523.1  
## 
```

```r
dim(gm.data.frame)
```

```
## [1] 1704    6
```

```r
str(gm.data.frame)
```

```
## 'data.frame':	1704 obs. of  6 variables:
##  $ country  : Factor w/ 142 levels "Afghanistan",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ continent: Factor w/ 5 levels "Africa","Americas",..: 3 3 3 3 3 3 3 3 3 3 ...
##  $ year     : int  1952 1957 1962 1967 1972 1977 1982 1987 1992 1997 ...
##  $ lifeExp  : num  28.8 30.3 32 34 36.1 ...
##  $ pop      : int  8425333 9240934 10267083 11537966 13079460 14880372 12881816 13867957 16317921 22227415 ...
##  $ gdpPercap: num  779 821 853 836 740 ...
```

```r
glimpse(gm_df)
```

```
## Observations: 1,704
## Variables: 6
## $ country   <fct> Afghanistan, Afghanistan, Afghanistan, Afghanistan, ...
## $ continent <fct> Asia, Asia, Asia, Asia, Asia, Asia, Asia, Asia, Asia...
## $ year      <int> 1952, 1957, 1962, 1967, 1972, 1977, 1982, 1987, 1992...
## $ lifeExp   <dbl> 28.801, 30.332, 31.997, 34.020, 36.088, 38.438, 39.8...
## $ pop       <int> 8425333, 9240934, 10267083, 11537966, 13079460, 1488...
## $ gdpPercap <dbl> 779.4453, 820.8530, 853.1007, 836.1971, 739.9811, 78...
```

# `select()` columns

<img src="select.png" width="703" style="display: block; margin: auto;" />

## Quick Example

### Initial Data


```r
sample_df %>%
  prettify()
```

<table class="table table-striped table-bordered table-condensed table-hover table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> country </th>
   <th style="text-align:left;"> continent </th>
   <th style="text-align:right;"> year </th>
   <th style="text-align:right;"> lifeExp </th>
   <th style="text-align:right;"> pop </th>
   <th style="text-align:right;"> gdpPercap </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Australia </td>
   <td style="text-align:left;"> Oceania </td>
   <td style="text-align:right;"> 2007 </td>
   <td style="text-align:right;"> 81.235 </td>
   <td style="text-align:right;"> 20434176 </td>
   <td style="text-align:right;"> 34435.367 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Brazil </td>
   <td style="text-align:left;"> Americas </td>
   <td style="text-align:right;"> 2007 </td>
   <td style="text-align:right;"> 72.390 </td>
   <td style="text-align:right;"> 190010647 </td>
   <td style="text-align:right;"> 9065.801 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Hungary </td>
   <td style="text-align:left;"> Europe </td>
   <td style="text-align:right;"> 2007 </td>
   <td style="text-align:right;"> 73.338 </td>
   <td style="text-align:right;"> 9956108 </td>
   <td style="text-align:right;"> 18008.944 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Ireland </td>
   <td style="text-align:left;"> Europe </td>
   <td style="text-align:right;"> 2007 </td>
   <td style="text-align:right;"> 78.885 </td>
   <td style="text-align:right;"> 4109086 </td>
   <td style="text-align:right;"> 40675.996 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> New Zealand </td>
   <td style="text-align:left;"> Oceania </td>
   <td style="text-align:right;"> 2007 </td>
   <td style="text-align:right;"> 80.204 </td>
   <td style="text-align:right;"> 4115771 </td>
   <td style="text-align:right;"> 25185.009 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Nicaragua </td>
   <td style="text-align:left;"> Americas </td>
   <td style="text-align:right;"> 2007 </td>
   <td style="text-align:right;"> 72.899 </td>
   <td style="text-align:right;"> 5675356 </td>
   <td style="text-align:right;"> 2749.321 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Nigeria </td>
   <td style="text-align:left;"> Africa </td>
   <td style="text-align:right;"> 2007 </td>
   <td style="text-align:right;"> 46.859 </td>
   <td style="text-align:right;"> 135031164 </td>
   <td style="text-align:right;"> 2013.977 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Singapore </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 2007 </td>
   <td style="text-align:right;"> 79.972 </td>
   <td style="text-align:right;"> 4553009 </td>
   <td style="text-align:right;"> 47143.180 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Sri Lanka </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 2007 </td>
   <td style="text-align:right;"> 72.396 </td>
   <td style="text-align:right;"> 20378239 </td>
   <td style="text-align:right;"> 3970.095 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Tunisia </td>
   <td style="text-align:left;"> Africa </td>
   <td style="text-align:right;"> 2007 </td>
   <td style="text-align:right;"> 73.923 </td>
   <td style="text-align:right;"> 10276158 </td>
   <td style="text-align:right;"> 7092.923 </td>
  </tr>
</tbody>
</table>

### End Data


```r
sample_df %>%
  select(country, pop) %>%
  prettify()
```

<table class="table table-striped table-bordered table-condensed table-hover table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> country </th>
   <th style="text-align:right;"> pop </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Australia </td>
   <td style="text-align:right;"> 20434176 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Brazil </td>
   <td style="text-align:right;"> 190010647 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Hungary </td>
   <td style="text-align:right;"> 9956108 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Ireland </td>
   <td style="text-align:right;"> 4109086 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> New Zealand </td>
   <td style="text-align:right;"> 4115771 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Nicaragua </td>
   <td style="text-align:right;"> 5675356 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Nigeria </td>
   <td style="text-align:right;"> 135031164 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Singapore </td>
   <td style="text-align:right;"> 4553009 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Sri Lanka </td>
   <td style="text-align:right;"> 20378239 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Tunisia </td>
   <td style="text-align:right;"> 10276158 </td>
  </tr>
</tbody>
</table>



The `select()` family is used to choose columns to keep. You can use bare (unquoted) names.

* `select()` columns by specific names.
    + select only `gm_df`'s `country` and `pop` columns


```r
gm_df %>%
  select(country, year, pop) %>%                  # select columns by specific names
  prettify()
```

<table class="table table-striped table-bordered table-condensed table-hover table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> country </th>
   <th style="text-align:right;"> year </th>
   <th style="text-align:right;"> pop </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:right;"> 1952 </td>
   <td style="text-align:right;"> 8425333 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:right;"> 1957 </td>
   <td style="text-align:right;"> 9240934 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:right;"> 1962 </td>
   <td style="text-align:right;"> 10267083 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:right;"> 1967 </td>
   <td style="text-align:right;"> 11537966 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:right;"> 1972 </td>
   <td style="text-align:right;"> 13079460 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:right;"> 1977 </td>
   <td style="text-align:right;"> 14880372 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:right;"> 1982 </td>
   <td style="text-align:right;"> 12881816 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:right;"> 1987 </td>
   <td style="text-align:right;"> 13867957 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:right;"> 1992 </td>
   <td style="text-align:right;"> 16317921 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:right;"> 1997 </td>
   <td style="text-align:right;"> 22227415 </td>
  </tr>
</tbody>
</table>

* `select()` a range of columns by name
    + select `gm_df`'s `continent` column and all columns from `lifeExp` to `gdpPercap`


```r
gm_df %>%
  select(continent, lifeExp:gdpPercap) %>%  # select columns name range
  prettify()
```

<table class="table table-striped table-bordered table-condensed table-hover table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> continent </th>
   <th style="text-align:right;"> lifeExp </th>
   <th style="text-align:right;"> pop </th>
   <th style="text-align:right;"> gdpPercap </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 28.801 </td>
   <td style="text-align:right;"> 8425333 </td>
   <td style="text-align:right;"> 779.4453 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 30.332 </td>
   <td style="text-align:right;"> 9240934 </td>
   <td style="text-align:right;"> 820.8530 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 31.997 </td>
   <td style="text-align:right;"> 10267083 </td>
   <td style="text-align:right;"> 853.1007 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 34.020 </td>
   <td style="text-align:right;"> 11537966 </td>
   <td style="text-align:right;"> 836.1971 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 36.088 </td>
   <td style="text-align:right;"> 13079460 </td>
   <td style="text-align:right;"> 739.9811 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 38.438 </td>
   <td style="text-align:right;"> 14880372 </td>
   <td style="text-align:right;"> 786.1134 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 39.854 </td>
   <td style="text-align:right;"> 12881816 </td>
   <td style="text-align:right;"> 978.0114 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 40.822 </td>
   <td style="text-align:right;"> 13867957 </td>
   <td style="text-align:right;"> 852.3959 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 41.674 </td>
   <td style="text-align:right;"> 16317921 </td>
   <td style="text-align:right;"> 649.3414 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 41.763 </td>
   <td style="text-align:right;"> 22227415 </td>
   <td style="text-align:right;"> 635.3414 </td>
  </tr>
</tbody>
</table>

* de`select()` a column with `-`
    + `select()` all of `gm_df`'s columns except `lifeExp`


```r
gm_df %>%
  select(-lifeExp) %>%                      # deselect column by name
  prettify()
```

<table class="table table-striped table-bordered table-condensed table-hover table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> country </th>
   <th style="text-align:left;"> continent </th>
   <th style="text-align:right;"> year </th>
   <th style="text-align:right;"> pop </th>
   <th style="text-align:right;"> gdpPercap </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1952 </td>
   <td style="text-align:right;"> 8425333 </td>
   <td style="text-align:right;"> 779.4453 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1957 </td>
   <td style="text-align:right;"> 9240934 </td>
   <td style="text-align:right;"> 820.8530 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1962 </td>
   <td style="text-align:right;"> 10267083 </td>
   <td style="text-align:right;"> 853.1007 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1967 </td>
   <td style="text-align:right;"> 11537966 </td>
   <td style="text-align:right;"> 836.1971 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1972 </td>
   <td style="text-align:right;"> 13079460 </td>
   <td style="text-align:right;"> 739.9811 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1977 </td>
   <td style="text-align:right;"> 14880372 </td>
   <td style="text-align:right;"> 786.1134 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1982 </td>
   <td style="text-align:right;"> 12881816 </td>
   <td style="text-align:right;"> 978.0114 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1987 </td>
   <td style="text-align:right;"> 13867957 </td>
   <td style="text-align:right;"> 852.3959 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1992 </td>
   <td style="text-align:right;"> 16317921 </td>
   <td style="text-align:right;"> 649.3414 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1997 </td>
   <td style="text-align:right;"> 22227415 </td>
   <td style="text-align:right;"> 635.3414 </td>
  </tr>
</tbody>
</table>

* de`select()` a range of columns by name
    + `select()` all of `gm_df`'s columns except those between `lifeExp` and `gdpPercap`


```r
gm_df %>%
  select(-c(lifeExp:gdpPercap)) %>%            # deselect column by name range
  prettify()
```

<table class="table table-striped table-bordered table-condensed table-hover table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> country </th>
   <th style="text-align:left;"> continent </th>
   <th style="text-align:right;"> year </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1952 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1957 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1962 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1967 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1972 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1977 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1982 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1987 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1992 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1997 </td>
  </tr>
</tbody>
</table>

* `select()` column by index
    + `select()` `gm_df`'s `4`th column


```r
gm_df %>%
  select(4) %>%                             # select column by index
  prettify()
```

<table class="table table-striped table-bordered table-condensed table-hover table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:right;"> lifeExp </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:right;"> 28.801 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 30.332 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 31.997 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 34.020 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 36.088 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 38.438 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 39.854 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 40.822 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 41.674 </td>
  </tr>
  <tr>
   <td style="text-align:right;"> 41.763 </td>
  </tr>
</tbody>
</table>

* de`select()` a column by index
    + `select()` all of `gm_df`'s columns except for the `4`th column


```r
gm_df %>%
  select(-4) %>%                            # deselect column by index
  prettify()
```

<table class="table table-striped table-bordered table-condensed table-hover table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> country </th>
   <th style="text-align:left;"> continent </th>
   <th style="text-align:right;"> year </th>
   <th style="text-align:right;"> pop </th>
   <th style="text-align:right;"> gdpPercap </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1952 </td>
   <td style="text-align:right;"> 8425333 </td>
   <td style="text-align:right;"> 779.4453 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1957 </td>
   <td style="text-align:right;"> 9240934 </td>
   <td style="text-align:right;"> 820.8530 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1962 </td>
   <td style="text-align:right;"> 10267083 </td>
   <td style="text-align:right;"> 853.1007 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1967 </td>
   <td style="text-align:right;"> 11537966 </td>
   <td style="text-align:right;"> 836.1971 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1972 </td>
   <td style="text-align:right;"> 13079460 </td>
   <td style="text-align:right;"> 739.9811 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1977 </td>
   <td style="text-align:right;"> 14880372 </td>
   <td style="text-align:right;"> 786.1134 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1982 </td>
   <td style="text-align:right;"> 12881816 </td>
   <td style="text-align:right;"> 978.0114 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1987 </td>
   <td style="text-align:right;"> 13867957 </td>
   <td style="text-align:right;"> 852.3959 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1992 </td>
   <td style="text-align:right;"> 16317921 </td>
   <td style="text-align:right;"> 649.3414 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1997 </td>
   <td style="text-align:right;"> 22227415 </td>
   <td style="text-align:right;"> 635.3414 </td>
  </tr>
</tbody>
</table>

* de`select()` a range of columns by index
    + `select()` all of `gm_df`'s columns except those between the `3`rd and `5`th columns


```r
gm_df %>%
  select(-c(3:5)) %>%                    # deselect columns by index range
  prettify()
```

<table class="table table-striped table-bordered table-condensed table-hover table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> country </th>
   <th style="text-align:left;"> continent </th>
   <th style="text-align:right;"> gdpPercap </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 779.4453 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 820.8530 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 853.1007 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 836.1971 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 739.9811 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 786.1134 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 978.0114 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 852.3959 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 649.3414 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 635.3414 </td>
  </tr>
</tbody>
</table>

# `ggplot()` Exercise 1

`{ggplot2}` is monster of a package used for data visualization that follows [The Grammar of Graphics](https://www.amazon.com/Grammar-Graphics-Statistics-Computing/dp/0387245448). 

`{ggplot2}` takes R's powerful graphics capabilities and makes them more accessible by taking care of many plotting tasks that are often tedious, while allowing for deep, lower-level customization.



* Basic Setup

<img src="ggplot_exercise_1.png" width="220" style="display: block; margin: auto;" />

`ggplot(`_your data_`, aes(x =`_x values_`, y =`_y values_`)) +` <br>
`geom_boxplot()` _the type of plot geometry desired_

Steps

1. Using `gm_df`, select the `lifeExp` column
2. Pipe (`%>%`) the result to `ggplot()`
3. Select the plot's `aes()`thetic values
    + `lifeExp` for the `x` values
        + a histogram's `y` are counts of its `x` values, so we don't provide them here
4. Add `geom_histogram()` as the geometry of the plot


```r
gm_df %>%                                     # data frame: Data
  select(lifeExp) %>%                         # columns to keep: Data
  ggplot(aes(x = lifeExp)) +                  # x values: Aesthetics
  geom_histogram()                            # histogram: Geometries
```

<div class="figure" style="text-align: center">
<img src="2018-03-15-tidyverse-getting-your-feet-wet_files/figure-html/unnamed-chunk-37-1.png" alt="Figure 1" width="1056" />
<p class="caption">Figure 1 Figure 1</p>
</div>




# `filter()` Rows

<img src="filter.png" width="751" style="display: block; margin: auto;" />

## Quick Example

### Initial Data


```r
sample_df %>%
  select(country, lifeExp) %>%
  prettify()
```

<table class="table table-striped table-bordered table-condensed table-hover table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> country </th>
   <th style="text-align:right;"> lifeExp </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Australia </td>
   <td style="text-align:right;"> 81.235 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Brazil </td>
   <td style="text-align:right;"> 72.390 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Hungary </td>
   <td style="text-align:right;"> 73.338 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Ireland </td>
   <td style="text-align:right;"> 78.885 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> New Zealand </td>
   <td style="text-align:right;"> 80.204 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Nicaragua </td>
   <td style="text-align:right;"> 72.899 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Nigeria </td>
   <td style="text-align:right;"> 46.859 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Singapore </td>
   <td style="text-align:right;"> 79.972 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Sri Lanka </td>
   <td style="text-align:right;"> 72.396 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Tunisia </td>
   <td style="text-align:right;"> 73.923 </td>
  </tr>
</tbody>
</table>

### End Data


```r
sample_df %>%
  select(country, lifeExp) %>%
  filter(lifeExp > 75) %>%
  prettify(cols_changed = 2)
```

<table class="table table-striped table-bordered table-condensed table-hover table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> country </th>
   <th style="text-align:right;"> lifeExp </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Australia </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 81.235 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Ireland </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 78.885 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> New Zealand </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 80.204 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Singapore </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 79.972 </td>
  </tr>
</tbody>
</table>


Use `filter()` to select rows using logic. Rows where a logical expression returns `TRUE` are kept and others are dropped.

* `filter()` rows where `numeric()` values are greater or lesser than another value
    + `filter()` `gm_df` to only keep rows where `gdpPercap < 500`


```r
gm_df %>%
  filter(gdpPercap < 500) %>%
  prettify(cols_changed = 6)
```

<table class="table table-striped table-bordered table-condensed table-hover table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> country </th>
   <th style="text-align:left;"> continent </th>
   <th style="text-align:right;"> year </th>
   <th style="text-align:right;"> lifeExp </th>
   <th style="text-align:right;"> pop </th>
   <th style="text-align:right;"> gdpPercap </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Burundi </td>
   <td style="text-align:left;"> Africa </td>
   <td style="text-align:right;"> 1952 </td>
   <td style="text-align:right;"> 39.031 </td>
   <td style="text-align:right;"> 2445618 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 339.2965 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Burundi </td>
   <td style="text-align:left;"> Africa </td>
   <td style="text-align:right;"> 1957 </td>
   <td style="text-align:right;"> 40.533 </td>
   <td style="text-align:right;"> 2667518 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 379.5646 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Burundi </td>
   <td style="text-align:left;"> Africa </td>
   <td style="text-align:right;"> 1962 </td>
   <td style="text-align:right;"> 42.045 </td>
   <td style="text-align:right;"> 2961915 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 355.2032 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Burundi </td>
   <td style="text-align:left;"> Africa </td>
   <td style="text-align:right;"> 1967 </td>
   <td style="text-align:right;"> 43.548 </td>
   <td style="text-align:right;"> 3330989 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 412.9775 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Burundi </td>
   <td style="text-align:left;"> Africa </td>
   <td style="text-align:right;"> 1972 </td>
   <td style="text-align:right;"> 44.057 </td>
   <td style="text-align:right;"> 3529983 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 464.0995 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Burundi </td>
   <td style="text-align:left;"> Africa </td>
   <td style="text-align:right;"> 1997 </td>
   <td style="text-align:right;"> 45.326 </td>
   <td style="text-align:right;"> 6121610 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 463.1151 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Burundi </td>
   <td style="text-align:left;"> Africa </td>
   <td style="text-align:right;"> 2002 </td>
   <td style="text-align:right;"> 47.360 </td>
   <td style="text-align:right;"> 7021078 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 446.4035 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Burundi </td>
   <td style="text-align:left;"> Africa </td>
   <td style="text-align:right;"> 2007 </td>
   <td style="text-align:right;"> 49.580 </td>
   <td style="text-align:right;"> 8390505 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 430.0707 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Cambodia </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1952 </td>
   <td style="text-align:right;"> 39.417 </td>
   <td style="text-align:right;"> 4693836 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 368.4693 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Cambodia </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1957 </td>
   <td style="text-align:right;"> 41.366 </td>
   <td style="text-align:right;"> 5322536 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 434.0383 </td>
  </tr>
</tbody>
</table>

* `filter()` rows using multiple logical expressions where all must be `TRUE`
    + `filter()` `gm_df` to only keep rows where `year > 1990` _and_ `lifeExp < 40`
    + `,` and `&` are evaluated identically in `filter()`


```r
gm_df %>%
  filter(year > 1990, lifeExp < 40) %>%
  prettify(cols_changed = 3:4)
```

<table class="table table-striped table-bordered table-condensed table-hover table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> country </th>
   <th style="text-align:left;"> continent </th>
   <th style="text-align:right;"> year </th>
   <th style="text-align:right;"> lifeExp </th>
   <th style="text-align:right;"> pop </th>
   <th style="text-align:right;"> gdpPercap </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Rwanda </td>
   <td style="text-align:left;"> Africa </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 1992 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 23.599 </td>
   <td style="text-align:right;"> 7290203 </td>
   <td style="text-align:right;"> 737.0686 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Rwanda </td>
   <td style="text-align:left;"> Africa </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 1997 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 36.087 </td>
   <td style="text-align:right;"> 7212583 </td>
   <td style="text-align:right;"> 589.9445 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Sierra Leone </td>
   <td style="text-align:left;"> Africa </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 1992 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 38.333 </td>
   <td style="text-align:right;"> 4260884 </td>
   <td style="text-align:right;"> 1068.6963 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Sierra Leone </td>
   <td style="text-align:left;"> Africa </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 1997 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 39.897 </td>
   <td style="text-align:right;"> 4578212 </td>
   <td style="text-align:right;"> 574.6482 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Somalia </td>
   <td style="text-align:left;"> Africa </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 1992 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 39.658 </td>
   <td style="text-align:right;"> 6099799 </td>
   <td style="text-align:right;"> 926.9603 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Swaziland </td>
   <td style="text-align:left;"> Africa </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 2007 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 39.613 </td>
   <td style="text-align:right;"> 1133066 </td>
   <td style="text-align:right;"> 4513.4806 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Zambia </td>
   <td style="text-align:left;"> Africa </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 2002 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 39.193 </td>
   <td style="text-align:right;"> 10595811 </td>
   <td style="text-align:right;"> 1071.6139 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Zimbabwe </td>
   <td style="text-align:left;"> Africa </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 2002 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 39.989 </td>
   <td style="text-align:right;"> 11926563 </td>
   <td style="text-align:right;"> 672.0386 </td>
  </tr>
</tbody>
</table>

* `filter()` rows using multiple logical expressions where one must be `TRUE`
    + `filter()` `gm_df` to only keep rows where `pop < 10000` _or_ `gdpPercap > 100000`
    + `|` means _or_


```r
gm_df %>%
  filter(pop < 10000 | gdpPercap > 100000) %>%
  prettify(cols_changed = 5:6)
```

<table class="table table-striped table-bordered table-condensed table-hover table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> country </th>
   <th style="text-align:left;"> continent </th>
   <th style="text-align:right;"> year </th>
   <th style="text-align:right;"> lifeExp </th>
   <th style="text-align:right;"> pop </th>
   <th style="text-align:right;"> gdpPercap </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Kuwait </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1952 </td>
   <td style="text-align:right;"> 55.565 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 160000 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 108382.4 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Kuwait </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1957 </td>
   <td style="text-align:right;"> 58.033 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 212846 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 113523.1 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Kuwait </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1972 </td>
   <td style="text-align:right;"> 67.712 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 841934 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 109347.9 </td>
  </tr>
</tbody>
</table>

* `filter()` rows using a string
    + `filter()` `gm_df` to only keep rows where `year` is `1999` and `continent` is `"Europe"`
    + `==` means _is equal to_


```r
gm_df %>%
  filter(year == 1997 & continent == "Europe") %>%
  prettify(cols_changed = 2:3)
```

<table class="table table-striped table-bordered table-condensed table-hover table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> country </th>
   <th style="text-align:left;"> continent </th>
   <th style="text-align:right;"> year </th>
   <th style="text-align:right;"> lifeExp </th>
   <th style="text-align:right;"> pop </th>
   <th style="text-align:right;"> gdpPercap </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Albania </td>
   <td style="text-align:left;font-weight: bold;color: black;background-color: #C8FAE3;"> Europe </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 1997 </td>
   <td style="text-align:right;"> 72.950 </td>
   <td style="text-align:right;"> 3428038 </td>
   <td style="text-align:right;"> 3193.055 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Austria </td>
   <td style="text-align:left;font-weight: bold;color: black;background-color: #C8FAE3;"> Europe </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 1997 </td>
   <td style="text-align:right;"> 77.510 </td>
   <td style="text-align:right;"> 8069876 </td>
   <td style="text-align:right;"> 29095.921 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Belgium </td>
   <td style="text-align:left;font-weight: bold;color: black;background-color: #C8FAE3;"> Europe </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 1997 </td>
   <td style="text-align:right;"> 77.530 </td>
   <td style="text-align:right;"> 10199787 </td>
   <td style="text-align:right;"> 27561.197 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Bosnia and Herzegovina </td>
   <td style="text-align:left;font-weight: bold;color: black;background-color: #C8FAE3;"> Europe </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 1997 </td>
   <td style="text-align:right;"> 73.244 </td>
   <td style="text-align:right;"> 3607000 </td>
   <td style="text-align:right;"> 4766.356 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Bulgaria </td>
   <td style="text-align:left;font-weight: bold;color: black;background-color: #C8FAE3;"> Europe </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 1997 </td>
   <td style="text-align:right;"> 70.320 </td>
   <td style="text-align:right;"> 8066057 </td>
   <td style="text-align:right;"> 5970.389 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Croatia </td>
   <td style="text-align:left;font-weight: bold;color: black;background-color: #C8FAE3;"> Europe </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 1997 </td>
   <td style="text-align:right;"> 73.680 </td>
   <td style="text-align:right;"> 4444595 </td>
   <td style="text-align:right;"> 9875.605 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Czech Republic </td>
   <td style="text-align:left;font-weight: bold;color: black;background-color: #C8FAE3;"> Europe </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 1997 </td>
   <td style="text-align:right;"> 74.010 </td>
   <td style="text-align:right;"> 10300707 </td>
   <td style="text-align:right;"> 16048.514 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Denmark </td>
   <td style="text-align:left;font-weight: bold;color: black;background-color: #C8FAE3;"> Europe </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 1997 </td>
   <td style="text-align:right;"> 76.110 </td>
   <td style="text-align:right;"> 5283663 </td>
   <td style="text-align:right;"> 29804.346 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Finland </td>
   <td style="text-align:left;font-weight: bold;color: black;background-color: #C8FAE3;"> Europe </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 1997 </td>
   <td style="text-align:right;"> 77.130 </td>
   <td style="text-align:right;"> 5134406 </td>
   <td style="text-align:right;"> 23723.950 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> France </td>
   <td style="text-align:left;font-weight: bold;color: black;background-color: #C8FAE3;"> Europe </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 1997 </td>
   <td style="text-align:right;"> 78.640 </td>
   <td style="text-align:right;"> 58623428 </td>
   <td style="text-align:right;"> 25889.785 </td>
  </tr>
</tbody>
</table>

# `ggplot()` Exercise 2

<img src="ggplot_exercise_1.png" width="220" style="display: block; margin: auto;" />

Steps

1. Using `gm_df`, select the `continent`, `country`, and `gdpPercap` columns
2. `filter()` the rows to only keep those where `continent == "Oceania"`
3. Pipe (`%>%`) the result to `ggplot()`
4. Select the plot's `aes()`thetic values
    + `country` for the `x` values
    + `gdpPercap` for the `y` values
4. Add `geom_boxplot()` as the geometry of the plot


```r
gm_df %>%                                         # data frame: Data
  select(continent, country, gdpPercap) %>%       # columns to keep: Data
  filter(continent == "Oceania") %>%              # rows to keep: Data
  ggplot(aes(x = country, y = gdpPercap)) +       # x and y values: Aesthetics
  geom_boxplot()                                  # box plot: Geometries
```

<img src="2018-03-15-tidyverse-getting-your-feet-wet_files/figure-html/unnamed-chunk-46-1.png" width="1056" style="display: block; margin: auto;" />

# `mutate()` Columns

<img src="mutate.png" width="739" style="display: block; margin: auto;" />

## Quick Example

### Initial Data


```r
sample_df %>%
  select(country, pop) %>%
  prettify()
```

<table class="table table-striped table-bordered table-condensed table-hover table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> country </th>
   <th style="text-align:right;"> pop </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Australia </td>
   <td style="text-align:right;"> 20434176 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Brazil </td>
   <td style="text-align:right;"> 190010647 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Hungary </td>
   <td style="text-align:right;"> 9956108 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Ireland </td>
   <td style="text-align:right;"> 4109086 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> New Zealand </td>
   <td style="text-align:right;"> 4115771 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Nicaragua </td>
   <td style="text-align:right;"> 5675356 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Nigeria </td>
   <td style="text-align:right;"> 135031164 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Singapore </td>
   <td style="text-align:right;"> 4553009 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Sri Lanka </td>
   <td style="text-align:right;"> 20378239 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Tunisia </td>
   <td style="text-align:right;"> 10276158 </td>
  </tr>
</tbody>
</table>

### End Data


```r
sample_df %>%
  select(country, pop) %>%
  mutate(pop_in_thousands = pop / 1000) %>%
  prettify(cols_changed = 3)
```

<table class="table table-striped table-bordered table-condensed table-hover table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> country </th>
   <th style="text-align:right;"> pop </th>
   <th style="text-align:right;"> pop_in_thousands </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Australia </td>
   <td style="text-align:right;"> 20434176 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 20434.176 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Brazil </td>
   <td style="text-align:right;"> 190010647 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 190010.647 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Hungary </td>
   <td style="text-align:right;"> 9956108 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 9956.108 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Ireland </td>
   <td style="text-align:right;"> 4109086 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 4109.086 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> New Zealand </td>
   <td style="text-align:right;"> 4115771 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 4115.771 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Nicaragua </td>
   <td style="text-align:right;"> 5675356 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 5675.356 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Nigeria </td>
   <td style="text-align:right;"> 135031164 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 135031.164 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Singapore </td>
   <td style="text-align:right;"> 4553009 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 4553.009 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Sri Lanka </td>
   <td style="text-align:right;"> 20378239 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 20378.239 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Tunisia </td>
   <td style="text-align:right;"> 10276158 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 10276.158 </td>
  </tr>
</tbody>
</table>


Use `mutate()` to manipulate column values and create new columns.

In order to `mutate()` a column, use the name of the column you are manipulating and set its value using `=`.

Here's a silly example:

* Add a new column to `gm_df`
    + `mutate()` `gm_df` to create a column named `planet` and set its value to `"Earth"`


```r
gm_df %>%
  mutate(planet = "Earth") %>%
  prettify(cols_changed = 7)
```

<table class="table table-striped table-bordered table-condensed table-hover table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> country </th>
   <th style="text-align:left;"> continent </th>
   <th style="text-align:right;"> year </th>
   <th style="text-align:right;"> lifeExp </th>
   <th style="text-align:right;"> pop </th>
   <th style="text-align:right;"> gdpPercap </th>
   <th style="text-align:left;"> planet </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1952 </td>
   <td style="text-align:right;"> 28.801 </td>
   <td style="text-align:right;"> 8425333 </td>
   <td style="text-align:right;"> 779.4453 </td>
   <td style="text-align:left;font-weight: bold;color: black;background-color: #C8FAE3;"> Earth </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1957 </td>
   <td style="text-align:right;"> 30.332 </td>
   <td style="text-align:right;"> 9240934 </td>
   <td style="text-align:right;"> 820.8530 </td>
   <td style="text-align:left;font-weight: bold;color: black;background-color: #C8FAE3;"> Earth </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1962 </td>
   <td style="text-align:right;"> 31.997 </td>
   <td style="text-align:right;"> 10267083 </td>
   <td style="text-align:right;"> 853.1007 </td>
   <td style="text-align:left;font-weight: bold;color: black;background-color: #C8FAE3;"> Earth </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1967 </td>
   <td style="text-align:right;"> 34.020 </td>
   <td style="text-align:right;"> 11537966 </td>
   <td style="text-align:right;"> 836.1971 </td>
   <td style="text-align:left;font-weight: bold;color: black;background-color: #C8FAE3;"> Earth </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1972 </td>
   <td style="text-align:right;"> 36.088 </td>
   <td style="text-align:right;"> 13079460 </td>
   <td style="text-align:right;"> 739.9811 </td>
   <td style="text-align:left;font-weight: bold;color: black;background-color: #C8FAE3;"> Earth </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1977 </td>
   <td style="text-align:right;"> 38.438 </td>
   <td style="text-align:right;"> 14880372 </td>
   <td style="text-align:right;"> 786.1134 </td>
   <td style="text-align:left;font-weight: bold;color: black;background-color: #C8FAE3;"> Earth </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1982 </td>
   <td style="text-align:right;"> 39.854 </td>
   <td style="text-align:right;"> 12881816 </td>
   <td style="text-align:right;"> 978.0114 </td>
   <td style="text-align:left;font-weight: bold;color: black;background-color: #C8FAE3;"> Earth </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1987 </td>
   <td style="text-align:right;"> 40.822 </td>
   <td style="text-align:right;"> 13867957 </td>
   <td style="text-align:right;"> 852.3959 </td>
   <td style="text-align:left;font-weight: bold;color: black;background-color: #C8FAE3;"> Earth </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1992 </td>
   <td style="text-align:right;"> 41.674 </td>
   <td style="text-align:right;"> 16317921 </td>
   <td style="text-align:right;"> 649.3414 </td>
   <td style="text-align:left;font-weight: bold;color: black;background-color: #C8FAE3;"> Earth </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1997 </td>
   <td style="text-align:right;"> 41.763 </td>
   <td style="text-align:right;"> 22227415 </td>
   <td style="text-align:right;"> 635.3414 </td>
   <td style="text-align:left;font-weight: bold;color: black;background-color: #C8FAE3;"> Earth </td>
  </tr>
</tbody>
</table>

Since we have `gdpPercap` and `pop`, we can calculate the values for a `total_GDP` column.

* `mutate()` `gm_df` to set the results of a calculation on each row to a new column
    + multiply `pop * gdpPercap` and assign the result to `total_GDP` inside `mutate()`


```r
gm_df %>%
  mutate(total_GDP = pop * gdpPercap) %>%
  prettify(cols_changed = 7)
```

<table class="table table-striped table-bordered table-condensed table-hover table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> country </th>
   <th style="text-align:left;"> continent </th>
   <th style="text-align:right;"> year </th>
   <th style="text-align:right;"> lifeExp </th>
   <th style="text-align:right;"> pop </th>
   <th style="text-align:right;"> gdpPercap </th>
   <th style="text-align:right;"> total_GDP </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1952 </td>
   <td style="text-align:right;"> 28.801 </td>
   <td style="text-align:right;"> 8425333 </td>
   <td style="text-align:right;"> 779.4453 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 6567086330 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1957 </td>
   <td style="text-align:right;"> 30.332 </td>
   <td style="text-align:right;"> 9240934 </td>
   <td style="text-align:right;"> 820.8530 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 7585448670 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1962 </td>
   <td style="text-align:right;"> 31.997 </td>
   <td style="text-align:right;"> 10267083 </td>
   <td style="text-align:right;"> 853.1007 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 8758855797 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1967 </td>
   <td style="text-align:right;"> 34.020 </td>
   <td style="text-align:right;"> 11537966 </td>
   <td style="text-align:right;"> 836.1971 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 9648014150 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1972 </td>
   <td style="text-align:right;"> 36.088 </td>
   <td style="text-align:right;"> 13079460 </td>
   <td style="text-align:right;"> 739.9811 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 9678553274 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1977 </td>
   <td style="text-align:right;"> 38.438 </td>
   <td style="text-align:right;"> 14880372 </td>
   <td style="text-align:right;"> 786.1134 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 11697659231 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1982 </td>
   <td style="text-align:right;"> 39.854 </td>
   <td style="text-align:right;"> 12881816 </td>
   <td style="text-align:right;"> 978.0114 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 12598563401 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1987 </td>
   <td style="text-align:right;"> 40.822 </td>
   <td style="text-align:right;"> 13867957 </td>
   <td style="text-align:right;"> 852.3959 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 11820990309 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1992 </td>
   <td style="text-align:right;"> 41.674 </td>
   <td style="text-align:right;"> 16317921 </td>
   <td style="text-align:right;"> 649.3414 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 10595901589 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1997 </td>
   <td style="text-align:right;"> 41.763 </td>
   <td style="text-align:right;"> 22227415 </td>
   <td style="text-align:right;"> 635.3414 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 14121995875 </td>
  </tr>
</tbody>
</table>

Typically, `mutate()` is used to perform operations across columns in each individual row. You can also use _summary functions_ to perform operations on individual columns (acting as vectors) that result in a vector that can be assigned to a column.

Makes sense, right??

Let's calculate the _z-score_ of each `gdpPercap` value for a specific year.

$$ z = \frac {x_i -\mu_x} {\sigma_x}$$

* $x$ = `gdpPercap`
* $\mu_x$ = the mean of $x$ = `mean(gdpPercap)`
* $\sigma_x$ = the standard deviation of x = `sd(gdpPercap)`

* Use a _summary function_ to perform a a calculation involving summary statistics of a column
    + subtract `mean(gdpPercap)` from `gdpPercap`
    + divide the result by `sd(gdpPercap)`
    + set the results as the values of a new column called `gdp_per_cap_z_score`


```r
gm_df %>%
  filter(year == 1977) %>%
  mutate(gdp_per_cap_z_score = (gdpPercap - mean(gdpPercap)) / sd(gdpPercap)) %>%
  prettify(cols_changed = 7)
```

<table class="table table-striped table-bordered table-condensed table-hover table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> country </th>
   <th style="text-align:left;"> continent </th>
   <th style="text-align:right;"> year </th>
   <th style="text-align:right;"> lifeExp </th>
   <th style="text-align:right;"> pop </th>
   <th style="text-align:right;"> gdpPercap </th>
   <th style="text-align:right;"> gdp_per_cap_z_score </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1977 </td>
   <td style="text-align:right;"> 38.438 </td>
   <td style="text-align:right;"> 14880372 </td>
   <td style="text-align:right;"> 786.1134 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> -0.7805156 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Albania </td>
   <td style="text-align:left;"> Europe </td>
   <td style="text-align:right;"> 1977 </td>
   <td style="text-align:right;"> 68.930 </td>
   <td style="text-align:right;"> 2509048 </td>
   <td style="text-align:right;"> 3533.0039 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> -0.4520380 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Algeria </td>
   <td style="text-align:left;"> Africa </td>
   <td style="text-align:right;"> 1977 </td>
   <td style="text-align:right;"> 58.014 </td>
   <td style="text-align:right;"> 17152804 </td>
   <td style="text-align:right;"> 4910.4168 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> -0.2873247 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Angola </td>
   <td style="text-align:left;"> Africa </td>
   <td style="text-align:right;"> 1977 </td>
   <td style="text-align:right;"> 39.483 </td>
   <td style="text-align:right;"> 6162675 </td>
   <td style="text-align:right;"> 3008.6474 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> -0.5147414 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Argentina </td>
   <td style="text-align:left;"> Americas </td>
   <td style="text-align:right;"> 1977 </td>
   <td style="text-align:right;"> 68.481 </td>
   <td style="text-align:right;"> 26983828 </td>
   <td style="text-align:right;"> 10079.0267 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 0.3307461 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Australia </td>
   <td style="text-align:left;"> Oceania </td>
   <td style="text-align:right;"> 1977 </td>
   <td style="text-align:right;"> 73.490 </td>
   <td style="text-align:right;"> 14074100 </td>
   <td style="text-align:right;"> 18334.1975 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 1.3179128 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Austria </td>
   <td style="text-align:left;"> Europe </td>
   <td style="text-align:right;"> 1977 </td>
   <td style="text-align:right;"> 72.170 </td>
   <td style="text-align:right;"> 7568430 </td>
   <td style="text-align:right;"> 19749.4223 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 1.4871476 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Bahrain </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1977 </td>
   <td style="text-align:right;"> 65.593 </td>
   <td style="text-align:right;"> 297410 </td>
   <td style="text-align:right;"> 19340.1020 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 1.4382004 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Bangladesh </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 1977 </td>
   <td style="text-align:right;"> 46.923 </td>
   <td style="text-align:right;"> 80428306 </td>
   <td style="text-align:right;"> 659.8772 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> -0.7956111 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Belgium </td>
   <td style="text-align:left;"> Europe </td>
   <td style="text-align:right;"> 1977 </td>
   <td style="text-align:right;"> 72.800 </td>
   <td style="text-align:right;"> 9821800 </td>
   <td style="text-align:right;"> 19117.9745 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 1.4116381 </td>
  </tr>
</tbody>
</table>

Here are other functions that can be used similarly:

Summary Functions |
----------------- | -----------------
`first()`         | `min()`
`last()`          | `max()`
`nth()`           | `mean()`
`n()`             | `median()`
`n_distinct()`    | `var()`
`IQR()`           | `sd()`

# `ggplot()` Exercise 3

<img src="ggplot_exercise_1.png" width="220" style="display: block; margin: auto;" />

Steps

1. Using `gm_df`, `select()` `country`, `year`, and `gdpPercap`
2. `filter()` the rows to keep only those where `country` is `"Korea, Rep."`, `"Korea, Dem. Rep."`, `"Japan"`, or `"China"`
3. Pipe the result to `ggplot()`
4. Select the plot's `aes()`thetic values
    + `year` for the `x` values
    + `gdpPercap` for the `y` values
    + __`country` for the `color` values__
* Add `geom_line()` as the geometry of the plot
* Add a `title` to the plot with `labs()`


```r
gm_df %>%
  filter(country %in% c("Korea, Rep.", "Korea, Dem. Rep.", "Japan", "China")) %>%
  mutate(total_GDP = pop * gdpPercap) %>%
  ggplot(aes(x = year, y = gdpPercap, color = country)) +
  geom_line() +
  labs(title = "GDP Over Time")
```

<img src="2018-03-15-tidyverse-getting-your-feet-wet_files/figure-html/unnamed-chunk-54-1.png" width="1056" style="display: block; margin: auto;" />

# `arrange()` Rows

## Quick Example

### Initial Data


```r
sample_df %>%
  select(country, gdpPercap) %>%
  prettify()
```

<table class="table table-striped table-bordered table-condensed table-hover table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> country </th>
   <th style="text-align:right;"> gdpPercap </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Australia </td>
   <td style="text-align:right;"> 34435.367 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Brazil </td>
   <td style="text-align:right;"> 9065.801 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Hungary </td>
   <td style="text-align:right;"> 18008.944 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Ireland </td>
   <td style="text-align:right;"> 40675.996 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> New Zealand </td>
   <td style="text-align:right;"> 25185.009 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Nicaragua </td>
   <td style="text-align:right;"> 2749.321 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Nigeria </td>
   <td style="text-align:right;"> 2013.977 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Singapore </td>
   <td style="text-align:right;"> 47143.180 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Sri Lanka </td>
   <td style="text-align:right;"> 3970.095 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Tunisia </td>
   <td style="text-align:right;"> 7092.923 </td>
  </tr>
</tbody>
</table>

### End Data


```r
sample_df %>%
  select(country, gdpPercap)%>%
  arrange(gdpPercap) %>%
  prettify(cols_changed = 2)
```

<table class="table table-striped table-bordered table-condensed table-hover table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> country </th>
   <th style="text-align:right;"> gdpPercap </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Nigeria </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 2013.977 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Nicaragua </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 2749.321 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Sri Lanka </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 3970.095 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Tunisia </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 7092.923 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Brazil </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 9065.801 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Hungary </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 18008.944 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> New Zealand </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 25185.009 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Australia </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 34435.367 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Ireland </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 40675.996 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Singapore </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 47143.180 </td>
  </tr>
</tbody>
</table>


Use `arrange()` to sort rows.

* `arrange()` by ascending number (smallest to largest)
    + `arrange()` `gm_df`'s `pop` column so that smallest populations are on top


```r
gm_df %>%
  arrange(pop) %>%
  prettify(cols_changed = 5)
```

<table class="table table-striped table-bordered table-condensed table-hover table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> country </th>
   <th style="text-align:left;"> continent </th>
   <th style="text-align:right;"> year </th>
   <th style="text-align:right;"> lifeExp </th>
   <th style="text-align:right;"> pop </th>
   <th style="text-align:right;"> gdpPercap </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Sao Tome and Principe </td>
   <td style="text-align:left;"> Africa </td>
   <td style="text-align:right;"> 1952 </td>
   <td style="text-align:right;"> 46.471 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 60011 </td>
   <td style="text-align:right;"> 879.5836 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Sao Tome and Principe </td>
   <td style="text-align:left;"> Africa </td>
   <td style="text-align:right;"> 1957 </td>
   <td style="text-align:right;"> 48.945 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 61325 </td>
   <td style="text-align:right;"> 860.7369 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Djibouti </td>
   <td style="text-align:left;"> Africa </td>
   <td style="text-align:right;"> 1952 </td>
   <td style="text-align:right;"> 34.812 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 63149 </td>
   <td style="text-align:right;"> 2669.5295 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Sao Tome and Principe </td>
   <td style="text-align:left;"> Africa </td>
   <td style="text-align:right;"> 1962 </td>
   <td style="text-align:right;"> 51.893 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 65345 </td>
   <td style="text-align:right;"> 1071.5511 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Sao Tome and Principe </td>
   <td style="text-align:left;"> Africa </td>
   <td style="text-align:right;"> 1967 </td>
   <td style="text-align:right;"> 54.425 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 70787 </td>
   <td style="text-align:right;"> 1384.8406 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Djibouti </td>
   <td style="text-align:left;"> Africa </td>
   <td style="text-align:right;"> 1957 </td>
   <td style="text-align:right;"> 37.328 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 71851 </td>
   <td style="text-align:right;"> 2864.9691 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Sao Tome and Principe </td>
   <td style="text-align:left;"> Africa </td>
   <td style="text-align:right;"> 1972 </td>
   <td style="text-align:right;"> 56.480 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 76595 </td>
   <td style="text-align:right;"> 1532.9853 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Sao Tome and Principe </td>
   <td style="text-align:left;"> Africa </td>
   <td style="text-align:right;"> 1977 </td>
   <td style="text-align:right;"> 58.550 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 86796 </td>
   <td style="text-align:right;"> 1737.5617 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Djibouti </td>
   <td style="text-align:left;"> Africa </td>
   <td style="text-align:right;"> 1962 </td>
   <td style="text-align:right;"> 39.693 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 89898 </td>
   <td style="text-align:right;"> 3020.9893 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Sao Tome and Principe </td>
   <td style="text-align:left;"> Africa </td>
   <td style="text-align:right;"> 1982 </td>
   <td style="text-align:right;"> 60.351 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 98593 </td>
   <td style="text-align:right;"> 1890.2181 </td>
  </tr>
</tbody>
</table>

* `arrange()` by `desc()` number (largest to smallest)
    + `arrange()` the `lifeExp` column so that largest values are on top


```r
gm_df %>%
  arrange(desc(lifeExp)) %>%
  prettify(cols_changed = 4)
```

<table class="table table-striped table-bordered table-condensed table-hover table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> country </th>
   <th style="text-align:left;"> continent </th>
   <th style="text-align:right;"> year </th>
   <th style="text-align:right;"> lifeExp </th>
   <th style="text-align:right;"> pop </th>
   <th style="text-align:right;"> gdpPercap </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Japan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 2007 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 82.603 </td>
   <td style="text-align:right;"> 127467972 </td>
   <td style="text-align:right;"> 31656.07 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Hong Kong, China </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 2007 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 82.208 </td>
   <td style="text-align:right;"> 6980412 </td>
   <td style="text-align:right;"> 39724.98 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Japan </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 2002 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 82.000 </td>
   <td style="text-align:right;"> 127065841 </td>
   <td style="text-align:right;"> 28604.59 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Iceland </td>
   <td style="text-align:left;"> Europe </td>
   <td style="text-align:right;"> 2007 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 81.757 </td>
   <td style="text-align:right;"> 301931 </td>
   <td style="text-align:right;"> 36180.79 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Switzerland </td>
   <td style="text-align:left;"> Europe </td>
   <td style="text-align:right;"> 2007 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 81.701 </td>
   <td style="text-align:right;"> 7554661 </td>
   <td style="text-align:right;"> 37506.42 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Hong Kong, China </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 2002 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 81.495 </td>
   <td style="text-align:right;"> 6762476 </td>
   <td style="text-align:right;"> 30209.02 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Australia </td>
   <td style="text-align:left;"> Oceania </td>
   <td style="text-align:right;"> 2007 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 81.235 </td>
   <td style="text-align:right;"> 20434176 </td>
   <td style="text-align:right;"> 34435.37 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Spain </td>
   <td style="text-align:left;"> Europe </td>
   <td style="text-align:right;"> 2007 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 80.941 </td>
   <td style="text-align:right;"> 40448191 </td>
   <td style="text-align:right;"> 28821.06 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Sweden </td>
   <td style="text-align:left;"> Europe </td>
   <td style="text-align:right;"> 2007 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 80.884 </td>
   <td style="text-align:right;"> 9031088 </td>
   <td style="text-align:right;"> 33859.75 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Israel </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 2007 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 80.745 </td>
   <td style="text-align:right;"> 6426679 </td>
   <td style="text-align:right;"> 25523.28 </td>
  </tr>
</tbody>
</table>

* `arrange()` alphabetically
    + `filter()` `gm_df` to keep only those rows where `year == 2007` and `continent == "Americas"`
    + `arrange()` the `country` column alphabetically


```r
gm_df %>%
  filter(year == 2007, continent == "Americas") %>%
  arrange(country) %>%
  prettify(cols_changed = 2:3)
```

<table class="table table-striped table-bordered table-condensed table-hover table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> country </th>
   <th style="text-align:left;"> continent </th>
   <th style="text-align:right;"> year </th>
   <th style="text-align:right;"> lifeExp </th>
   <th style="text-align:right;"> pop </th>
   <th style="text-align:right;"> gdpPercap </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Argentina </td>
   <td style="text-align:left;font-weight: bold;color: black;background-color: #C8FAE3;"> Americas </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 2007 </td>
   <td style="text-align:right;"> 75.320 </td>
   <td style="text-align:right;"> 40301927 </td>
   <td style="text-align:right;"> 12779.380 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Bolivia </td>
   <td style="text-align:left;font-weight: bold;color: black;background-color: #C8FAE3;"> Americas </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 2007 </td>
   <td style="text-align:right;"> 65.554 </td>
   <td style="text-align:right;"> 9119152 </td>
   <td style="text-align:right;"> 3822.137 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Brazil </td>
   <td style="text-align:left;font-weight: bold;color: black;background-color: #C8FAE3;"> Americas </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 2007 </td>
   <td style="text-align:right;"> 72.390 </td>
   <td style="text-align:right;"> 190010647 </td>
   <td style="text-align:right;"> 9065.801 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Canada </td>
   <td style="text-align:left;font-weight: bold;color: black;background-color: #C8FAE3;"> Americas </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 2007 </td>
   <td style="text-align:right;"> 80.653 </td>
   <td style="text-align:right;"> 33390141 </td>
   <td style="text-align:right;"> 36319.235 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Chile </td>
   <td style="text-align:left;font-weight: bold;color: black;background-color: #C8FAE3;"> Americas </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 2007 </td>
   <td style="text-align:right;"> 78.553 </td>
   <td style="text-align:right;"> 16284741 </td>
   <td style="text-align:right;"> 13171.639 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Colombia </td>
   <td style="text-align:left;font-weight: bold;color: black;background-color: #C8FAE3;"> Americas </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 2007 </td>
   <td style="text-align:right;"> 72.889 </td>
   <td style="text-align:right;"> 44227550 </td>
   <td style="text-align:right;"> 7006.580 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Costa Rica </td>
   <td style="text-align:left;font-weight: bold;color: black;background-color: #C8FAE3;"> Americas </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 2007 </td>
   <td style="text-align:right;"> 78.782 </td>
   <td style="text-align:right;"> 4133884 </td>
   <td style="text-align:right;"> 9645.061 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Cuba </td>
   <td style="text-align:left;font-weight: bold;color: black;background-color: #C8FAE3;"> Americas </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 2007 </td>
   <td style="text-align:right;"> 78.273 </td>
   <td style="text-align:right;"> 11416987 </td>
   <td style="text-align:right;"> 8948.103 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Dominican Republic </td>
   <td style="text-align:left;font-weight: bold;color: black;background-color: #C8FAE3;"> Americas </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 2007 </td>
   <td style="text-align:right;"> 72.235 </td>
   <td style="text-align:right;"> 9319622 </td>
   <td style="text-align:right;"> 6025.375 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Ecuador </td>
   <td style="text-align:left;font-weight: bold;color: black;background-color: #C8FAE3;"> Americas </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 2007 </td>
   <td style="text-align:right;"> 74.994 </td>
   <td style="text-align:right;"> 13755680 </td>
   <td style="text-align:right;"> 6873.262 </td>
  </tr>
</tbody>
</table>


# `group_by()` for Grouped Data

<img src="group_by.png" width="807" style="display: block; margin: auto;" />

## Quick Example

### Initial Data


```r
sample_df %>%
  select(country, continent, pop) %>%
  prettify()
```

<table class="table table-striped table-bordered table-condensed table-hover table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> country </th>
   <th style="text-align:left;"> continent </th>
   <th style="text-align:right;"> pop </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Australia </td>
   <td style="text-align:left;"> Oceania </td>
   <td style="text-align:right;"> 20434176 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Brazil </td>
   <td style="text-align:left;"> Americas </td>
   <td style="text-align:right;"> 190010647 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Hungary </td>
   <td style="text-align:left;"> Europe </td>
   <td style="text-align:right;"> 9956108 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Ireland </td>
   <td style="text-align:left;"> Europe </td>
   <td style="text-align:right;"> 4109086 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> New Zealand </td>
   <td style="text-align:left;"> Oceania </td>
   <td style="text-align:right;"> 4115771 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Nicaragua </td>
   <td style="text-align:left;"> Americas </td>
   <td style="text-align:right;"> 5675356 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Nigeria </td>
   <td style="text-align:left;"> Africa </td>
   <td style="text-align:right;"> 135031164 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Singapore </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 4553009 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Sri Lanka </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 20378239 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Tunisia </td>
   <td style="text-align:left;"> Africa </td>
   <td style="text-align:right;"> 10276158 </td>
  </tr>
</tbody>
</table>

### End Data


```r
sample_df %>%
  select(country, continent, pop) %>%
  group_by(continent) %>%
  mutate(pop_by_continent = sum(pop)) %>%
  ungroup() %>%
  arrange(pop_by_continent) %>%
  prettify(cols_changed = 4)
```

<table class="table table-striped table-bordered table-condensed table-hover table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> country </th>
   <th style="text-align:left;"> continent </th>
   <th style="text-align:right;"> pop </th>
   <th style="text-align:right;"> pop_by_continent </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Hungary </td>
   <td style="text-align:left;"> Europe </td>
   <td style="text-align:right;"> 9956108 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 14065194 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Ireland </td>
   <td style="text-align:left;"> Europe </td>
   <td style="text-align:right;"> 4109086 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 14065194 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Australia </td>
   <td style="text-align:left;"> Oceania </td>
   <td style="text-align:right;"> 20434176 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 24549947 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> New Zealand </td>
   <td style="text-align:left;"> Oceania </td>
   <td style="text-align:right;"> 4115771 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 24549947 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Singapore </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 4553009 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 24931248 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Sri Lanka </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 20378239 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 24931248 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Nigeria </td>
   <td style="text-align:left;"> Africa </td>
   <td style="text-align:right;"> 135031164 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 145307322 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Tunisia </td>
   <td style="text-align:left;"> Africa </td>
   <td style="text-align:right;"> 10276158 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 145307322 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Brazil </td>
   <td style="text-align:left;"> Americas </td>
   <td style="text-align:right;"> 190010647 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 195686003 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Nicaragua </td>
   <td style="text-align:left;"> Americas </td>
   <td style="text-align:right;"> 5675356 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 195686003 </td>
  </tr>
</tbody>
</table>


`group_by()` allows us to group rows together based on column values.

Let's say we wanted to compute summary values for each country for all years.

* Calculate the `mean_gdp_per_cap` of each `country` with `group_by()`
    + take `gm_df` and `group_by()` `country` to group rows of the same country together
    + use `mean()` to calculate the `mean_gdp_per_cap`
    + `ungroup()` the rows
        + a habit you want
    + keep only those rows with `distinct()` combinations of `country` and `mean_gdp_per_cap`
        + `distinct()`'s default is to only keep columns used as arguments


```r
gm_df %>%
  group_by(country) %>%
  mutate(mean_gdp_per_cap = median(gdpPercap)) %>% 
  ungroup() %>%
  distinct(country, mean_gdp_per_cap) %>% 
  prettify(cols_changed = 2)
```

<table class="table table-striped table-bordered table-condensed table-hover table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> country </th>
   <th style="text-align:right;"> mean_gdp_per_cap </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Afghanistan </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 803.4832 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Albania </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 3253.2384 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Algeria </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 4853.8559 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Angola </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 3264.6288 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Argentina </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 9068.7844 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Australia </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 18905.6034 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Austria </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 20673.2530 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Bahrain </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 18779.8016 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Bangladesh </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 703.7638 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Belgium </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 20048.9102 </td>
  </tr>
</tbody>
</table>

# `ggplot()` Exercise 4

<img src="ggplot_exercise_1.png" width="220" style="display: block; margin: auto;" />

Steps

1. Using `gm_df`, `group_by()` the `continent` and `year`
2. `mutate()` to add a column called `mean_gdp` for the average GDP of each continent
3. `ungroup()` the data, because this is a habit that will save you headaches later
4. Keep only `distinct()` combinations of `continent`, `year`, and `mean_gdp`
3. Pipe the result to `ggplot()`
4. Select the plot's `aes()`thetic values
    + `year` for the `x` values
    + `mean_gdp` for the `y` values
    + `continent` for the `color` values
5. Add `geom_line()` as the geometry of the plot
6. Add a `title` and a `caption` (for the source of the data) to the plot with `labs()`


```r
gm_df %>%
  group_by(year, continent) %>%
  mutate(mean_gdp = mean(gdpPercap)) %>%
  ungroup() %>%
  distinct(continent, year, mean_gdp) %>%
  ggplot(aes(x = year, y = mean_gdp, color = continent)) +
  geom_line() +
  labs(title = "Mean GDPs by Continent Over Time",
       caption = "Source: Free material from www.gapminder.org")
```

<img src="2018-03-15-tidyverse-getting-your-feet-wet_files/figure-html/unnamed-chunk-65-1.png" width="1056" style="display: block; margin: auto;" />

# `summarize()`

<img src="summarize.png" width="698" style="display: block; margin: auto;" />

## Quick Example

### Initial Data


```r
sample_df %>%
  select(country, continent, lifeExp, pop) %>%
  prettify()
```

<table class="table table-striped table-bordered table-condensed table-hover table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> country </th>
   <th style="text-align:left;"> continent </th>
   <th style="text-align:right;"> lifeExp </th>
   <th style="text-align:right;"> pop </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Australia </td>
   <td style="text-align:left;"> Oceania </td>
   <td style="text-align:right;"> 81.235 </td>
   <td style="text-align:right;"> 20434176 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Brazil </td>
   <td style="text-align:left;"> Americas </td>
   <td style="text-align:right;"> 72.390 </td>
   <td style="text-align:right;"> 190010647 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Hungary </td>
   <td style="text-align:left;"> Europe </td>
   <td style="text-align:right;"> 73.338 </td>
   <td style="text-align:right;"> 9956108 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Ireland </td>
   <td style="text-align:left;"> Europe </td>
   <td style="text-align:right;"> 78.885 </td>
   <td style="text-align:right;"> 4109086 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> New Zealand </td>
   <td style="text-align:left;"> Oceania </td>
   <td style="text-align:right;"> 80.204 </td>
   <td style="text-align:right;"> 4115771 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Nicaragua </td>
   <td style="text-align:left;"> Americas </td>
   <td style="text-align:right;"> 72.899 </td>
   <td style="text-align:right;"> 5675356 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Nigeria </td>
   <td style="text-align:left;"> Africa </td>
   <td style="text-align:right;"> 46.859 </td>
   <td style="text-align:right;"> 135031164 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Singapore </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 79.972 </td>
   <td style="text-align:right;"> 4553009 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Sri Lanka </td>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;"> 72.396 </td>
   <td style="text-align:right;"> 20378239 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Tunisia </td>
   <td style="text-align:left;"> Africa </td>
   <td style="text-align:right;"> 73.923 </td>
   <td style="text-align:right;"> 10276158 </td>
  </tr>
</tbody>
</table>


```r
sample_df %>%
  select(country, continent, lifeExp, pop) %>%
  group_by(continent) %>%
  summarise(max_pop = max(pop),
            mean_life_exp = mean(lifeExp)) %>%
  prettify(cols_changed = 2:3)
```

<table class="table table-striped table-bordered table-condensed table-hover table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> continent </th>
   <th style="text-align:right;"> max_pop </th>
   <th style="text-align:right;"> mean_life_exp </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Africa </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 135031164 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 60.3910 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Americas </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 190010647 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 72.6445 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 20378239 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 76.1840 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Europe </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 9956108 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 76.1115 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Oceania </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 20434176 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 80.7195 </td>
  </tr>
</tbody>
</table>


Now that we know how to use `group_by()`, we can `summarize()` data by group. This can be done using all of the _summary functions_ seen earlier.

Summary Functions |
----------------- | -----------------
`first()`         | `min()`
`last()`          | `max()`
`nth()`           | `mean()`
`n()`             | `median()`
`n_distinct()`    | `var()`
`IQR()`           | `sd()`

* Calculate some summary statitics for each continent.
    + take `gm_df` and `group_by()` `continent`
    + using `summarize()` or `summarise()`, calculate:
        + `count` with `n()`
        + `mean_pop` with `mean()`
        + `max_gdp_per_cap` with `max()`


```r
gm_df %>%
  group_by(continent) %>%
  summarise(count = n(),
            mean_pop = mean(pop),
            max_gdp_per_cap = max(gdpPercap)) %>%
  prettify(cols_changed = 2:4)
```

<table class="table table-striped table-bordered table-condensed table-hover table-responsive" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> continent </th>
   <th style="text-align:right;"> count </th>
   <th style="text-align:right;"> mean_pop </th>
   <th style="text-align:right;"> max_gdp_per_cap </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> Africa </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 624 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 9916003 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 21951.21 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Americas </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 300 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 24504795 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 42951.65 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Asia </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 396 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 77038722 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 113523.13 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Europe </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 360 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 17169765 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 49357.19 </td>
  </tr>
  <tr>
   <td style="text-align:left;"> Oceania </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 24 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 8874672 </td>
   <td style="text-align:right;font-weight: bold;color: black;background-color: #C8FAE3;"> 34435.37 </td>
  </tr>
</tbody>
</table>

# `ggplot()` Exercise 5

<img src="ggplot_layers_all.png" width="220" style="display: block; margin: auto;" />

Steps

1. Using `gm_df`, `filter()` the data to remove rows where `continent` is not `"Oceania"`
3. `group_by()` `continent` and `year` 
4. `summarize()` the groups by calculating them `mean()` of `pop`
5. `ungroup()` the data, because this is a habit that will save you headaches later
6. Pipe the results to `ggplot()`
7. Select the plot's `aes()`thetics
    + `year` for the `x` values
    + `mean_pop` for the `y` values
    + `continent` for the `color` values
8. Add `geom_line()` for the first geometry
9. Add `geom_point()` for the second geometry
10. Change the theme by adding `theme_minimal()`
11. Using `facet_wrap()`, split the plot into panels for each `continent`
    + `~` is used as a `formula` to select the facet variable
12. Add a `title` and a `caption` with `labs()`



```r
gm_df %>%
  filter(continent != "Oceania") %>%
  group_by(continent, year) %>%
  summarise(mean_pop = mean(pop)) %>%
  ungroup() %>%
  ggplot(aes(x = year, y = mean_pop,
             color = continent)) +
  geom_line() +
  geom_point() +
  theme_minimal() +
  facet_wrap(~ continent) +
  labs(title = "Mean Continent Populations over Time",
       caption = "Source: Free material from www.gapminder.org")
```

<img src="2018-03-15-tidyverse-getting-your-feet-wet_files/figure-html/unnamed-chunk-71-1.png" width="1056" style="display: block; margin: auto;" />



