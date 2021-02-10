---
title: GDPR Violations
author: Robert W. Walker
date: '2020-04-25'
slug: gdpr-violations
categories:
  - Maps
  - Public Finance
tags:
  - tidyTuesday
  - plot
subtitle: ''
summary: ''
authors: []
lastmod: '2020-04-25T18:55:35-07:00'
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: no
projects: []
---

## R Markdown

I love this intro photo from the tidyTuesday page.

![](https://camo.githubusercontent.com/0c831f8d61fee52c54b4edf861012ea51643195f/68747470733a2f2f776f726470726573732e736d6172746c6f6f6b2e636f6d2f77702d636f6e74656e742f75706c6f6164732f323031382f30312f676470722e706e67)

This week's tidyTuesday data cover violations of the GDPR (General Data Protection Regulations) regulatory regime for data privacy in the European Union.  [The Wikipedia entry on GDPR](https://en.wikipedia.org/wiki/General_Data_Protection_Regulation) is fairly extensive.  The dataset is large and suggests some interesting regulatory arbitrage.  Some countries have far more violations; others have a large number but vary considerably in size of fine.  Let's have a look at the data.  First, let's load them.


```r
gdpr_violations <- readr::read_tsv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-04-21/gdpr_violations.tsv')
```

```
## 
## ── Column specification ────────────────────────────────────────────────────────
## cols(
##   id = col_double(),
##   picture = col_character(),
##   name = col_character(),
##   price = col_double(),
##   authority = col_character(),
##   date = col_character(),
##   controller = col_character(),
##   article_violated = col_character(),
##   type = col_character(),
##   source = col_character(),
##   summary = col_character()
## )
```

```r
gdpr_text <- readr::read_tsv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-04-21/gdpr_text.tsv')
```

```
## 
## ── Column specification ────────────────────────────────────────────────────────
## cols(
##   chapter = col_double(),
##   chapter_title = col_character(),
##   article = col_double(),
##   article_title = col_character(),
##   sub_article = col_double(),
##   gdpr_text = col_character(),
##   href = col_character()
## )
```

## Summary



```r
library(skimr)
skim(gdpr_violations)
```


Table: Table 1: Data summary

|                         |                |
|:------------------------|:---------------|
|Name                     |gdpr_violations |
|Number of rows           |250             |
|Number of columns        |11              |
|_______________________  |                |
|Column type frequency:   |                |
|character                |9               |
|numeric                  |2               |
|________________________ |                |
|Group variables          |None            |


**Variable type: character**

|skim_variable    | n_missing| complete_rate| min|  max| empty| n_unique| whitespace|
|:----------------|---------:|-------------:|---:|----:|-----:|--------:|----------:|
|picture          |         0|             1|  67|   80|     0|       25|          0|
|name             |         0|             1|   5|   14|     0|       25|          0|
|authority        |         0|             1|  14|   86|     0|       40|          0|
|date             |         0|             1|  10|   10|     0|      140|          0|
|controller       |         0|             1|   2|   93|     0|      187|          0|
|article_violated |         0|             1|   7|   87|     0|       86|          0|
|type             |         0|             1|   7|  143|     0|       22|          0|
|source           |         0|             1|  29|  209|     0|      218|          0|
|summary          |         0|             1|  13| 1550|     0|      238|          0|


**Variable type: numeric**

|skim_variable | n_missing| complete_rate|     mean|         sd| p0|     p25|     p50|      p75|    p100|hist  |
|:-------------|---------:|-------------:|--------:|----------:|--:|-------:|-------:|--------:|-------:|:-----|
|id            |         0|             1|    125.5|      72.31|  1|   63.25|   125.5|   187.75| 2.5e+02|▇▇▇▇▇ |
|price         |         0|             1| 613214.0| 3980371.95|  0| 2500.00| 10500.0| 60000.00| 5.0e+07|▇▁▁▁▁ |

## Violations


```r
library(tidyverse); library(janitor)
```

```
## ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.0 ──
```

```
## ✓ ggplot2 3.3.3     ✓ purrr   0.3.4
## ✓ tibble  3.0.6     ✓ dplyr   1.0.4
## ✓ tidyr   1.1.2     ✓ stringr 1.4.0
## ✓ readr   1.4.0     ✓ forcats 0.5.1
```

```
## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
## x dplyr::filter() masks stats::filter()
## x dplyr::lag()    masks stats::lag()
```

```
## 
## Attaching package: 'janitor'
```

```
## The following objects are masked from 'package:stats':
## 
##     chisq.test, fisher.test
```

```r
gdpr_violations %>% tabyl(article_violated)
```

```
##                                                                         article_violated
##                                     Art 6 (1) GDPR|Art 58 (2) e) GDPR|Art 83 (5) a) GDPR
##                                                        Art. 12 (3) GDPR|Art. 15 (1) GDPR
##                                                            Art. 12 (4) GDPR|Art. 15 GDPR
##                           Art. 12 (4) GDPR|Art. 15 GDPR|Art. 18 (1) c) GDPR|Art. 13 GDPR
##                                 Art. 12 GDPR|Art. 13 GDPR|Art. 5 (1) c) GDPR|Art. 6 GDPR
##                                                                Art. 12 GDPR|Art. 15 GDPR
##                                                   Art. 12 GDPR|Art. 15 GDPR|Art. 17 GDPR
##                                                                Art. 12 GDPR|Art. 17 GDPR
##                                                                             Art. 13 GDPR
##                            Art. 13 GDPR|Art. 14 GDPR|Art. 6 GDPR|Art. 4 GDPR|Art. 5 GDPR
##                                                                Art. 13 GDPR|Art. 37 GDPR
##                                                                             Art. 14 GDPR
##                                                                    Art. 15 (1), (3) GDPR
##                                                                             Art. 15 GDPR
##                                                   Art. 15 GDPR|Art. 17 GDPR|Art. 21 GDPR
##                                                                             Art. 17 GDPR
##                                                            Art. 21 (3) GDPR|Art. 25 GDPR
##                                                                             Art. 21 GDPR
##                                                      Art. 25 (1) GDPR|Art. 5 (1) c) GDPR
##                                                                             Art. 25 GDPR
##                                                                         Art. 28 (3) GDPR
##                                                                             Art. 28 GDPR
##                                                                      Art. 28 of the GDPR
##                                                                             Art. 31 GDPR
##                                                                             Art. 32 GDPR
##                                                                Art. 32 GDPR|Art. 33 GDPR
##                                       Art. 33 (1) GDPR|Art. 33 (5) GDPR|Art. 34 (1) GDPR
##                                                                             Art. 33 GDPR
##                                                                Art. 33 GDPR|Art. 34 GDPR
##                                                                             Art. 37 GDPR
##                                                                       Art. 5 (1) a) GDPR
##                                   Art. 5 (1) a) GDPR|Art. 5 (1) b) GDPR|Art. 32 (1) GDPR
##                                                    Art. 5 (1) a) GDPR|Art. 5 (1) c) GDPR
##                       Art. 5 (1) a) GDPR|Art. 5 (1) c) GDPR|Art. 6 (1) GDPR|Art. 13 GDPR
##                                                    Art. 5 (1) a) GDPR|Art. 6 (1) a) GDPR
##                                                           Art. 5 (1) a) GDPR|Art. 6 GDPR
##                       Art. 5 (1) a) GDPR|Art. 9 (1) GDPR|Art. 9 (2) GDPR|Art. 6 (1) GDPR
##                                                                  Art. 5 (1) a), (2) GDPR
##                                                            Art. 5 (1) a)|Art. 7 (3) GDPR
##  Art. 5 (1) b) GDPR|Art. 5 (1) c) GDPR|Art. 13 (3) GDPR|Art. 17 (1) GDPR|Art. 6 (4) GDRP
##                                                           Art. 5 (1) b) GDPR|Art. 6 GDPR
##                                                                       Art. 5 (1) c) GDPR
##                                Art. 5 (1) c) GDPR|Art. 12 GDPR|Art. 13 GDPR|Art. 32 GDPR
##                                                          Art. 5 (1) c) GDPR|Art. 13 GDPR
##                                                          Art. 5 (1) c) GDPR|Art. 25 GDPR
##                                                    Art. 5 (1) c) GDPR|Art. 5 (1) e) GDPR
##                                 Art. 5 (1) c) GDPR|Art. 9 GDPR|Art. 35 GDPR|Art. 36 GDPR
##                                                                       Art. 5 (1) d) GDPR
##                                                       Art. 5 (1) e) GDPR|Art. 5 (2) GDPR
##                                                                       Art. 5 (1) f) GDPR
##                                                          Art. 5 (1) f) GDPR|Art. 32 GDPR
##                                                                          Art. 5 (1) GDPR
##  Art. 5 (1) GDPR|Art. 5 (2) GDPR|Art. 6 (1) GDPR|Art. 13 (1) c) GDPR|Art. 14 (1) c) GDPR
##                                                  Art. 5 (1) GDPR|Art. 6 GDPR|Art. 7 GDPR
##                                      Art. 5 (1) GDPR|Art. 6 GDPR|Art. 7 GDPR|Art. 9 GDPR
##                                                                              Art. 5 GDPR
##                                                                 Art. 5 GDPR|Art. 25 GDPR
##                                       Art. 5 GDPR|Art. 25 GDPR|Art. 32 GDPR|Art. 33 GDPR
##                                                                 Art. 5 GDPR|Art. 32 GDPR
##                                                    Art. 5 GDPR|Art. 32 GDPR|Art. 33 GDPR
##                                                                  Art. 5 GDPR|Art. 6 GDPR
##                           Art. 5 GDPR|Art. 6 GDPR|Art. 13 GDPR|Art. 14 GDPR|Art. 21 GDPR
##                                                     Art. 5 GDPR|Art. 6 GDPR|Art. 17 GDPR
##                                        Art. 5 GDPR|Art. 6 GDPR|Art. 17 GDPR|Art. 21 GDPR
##                                                     Art. 5 GDPR|Art. 6 GDPR|Art. 21 GDPR
##                                                     Art. 5 GDPR|Art. 6 GDPR|Art. 32 GDPR
##                                         Art. 5 GDPR|Art. 6 GDPR|Art. 7 GDPR|Art. 21 GDPR
##                                                                        Art. 5(1) e) GDPR
##                                                                             Art. 58 GDPR
##                                                                          Art. 58(2) GDPR
##                                                                          Art. 6 (1) GDPR
##                                                         Art. 6 (1) GDPR|Art. 25 (1) GDPR
##                                                                              Art. 6 GDPR
##                                                    Art. 6 GDPR|Art. 12 GDPR|Art. 13 GDPR
##                                                                 Art. 6 GDPR|Art. 21 GDPR
##                                                           Art. 6 GDPR|Art. 5 (1) a) GDPR
##                                              Art. 6 GDPR|Art. 5 (1) b) GDPR|Art. 13 GDPR
##                                                                  Art. 6 GDPR|Art. 5 GDPR
##                                                                  Art. 6 GDPR|Art. 7 GDPR
##                                                                  Art. 6 GDPR|Art. 9 GDPR
##                                    Art. 83 (4) a) GDPR|Art. 33 (1) GDPR|Art. 34 (1) GDPR
##                                                                              Art.14 GDPR
##                                                                       Art.14 of the GDPR
##                                                                 Data Protection Act 2018
##                  Failure to implement sufficient measures to ensure information security
##                                                                                  Unknown
##   n percent
##   1   0.004
##   1   0.004
##   1   0.004
##   1   0.004
##   1   0.004
##   1   0.004
##   1   0.004
##   1   0.004
##   7   0.028
##   1   0.004
##   1   0.004
##   1   0.004
##   1   0.004
##  10   0.040
##   1   0.004
##   1   0.004
##   1   0.004
##   1   0.004
##   1   0.004
##   1   0.004
##   1   0.004
##   1   0.004
##   1   0.004
##   2   0.008
##  41   0.164
##   2   0.008
##   1   0.004
##   1   0.004
##   1   0.004
##   2   0.008
##   2   0.008
##   1   0.004
##   1   0.004
##   1   0.004
##   2   0.008
##   6   0.024
##   1   0.004
##   1   0.004
##   1   0.004
##   1   0.004
##   2   0.008
##   6   0.024
##   1   0.004
##   1   0.004
##   1   0.004
##   1   0.004
##   1   0.004
##   3   0.012
##   1   0.004
##   7   0.028
##  10   0.040
##   1   0.004
##   1   0.004
##   1   0.004
##   1   0.004
##  10   0.040
##   2   0.008
##   1   0.004
##   3   0.012
##   1   0.004
##  20   0.080
##   1   0.004
##   1   0.004
##   1   0.004
##   2   0.008
##   1   0.004
##   1   0.004
##   1   0.004
##   5   0.020
##   1   0.004
##   4   0.016
##   1   0.004
##  33   0.132
##   1   0.004
##   1   0.004
##   2   0.008
##   1   0.004
##   1   0.004
##   1   0.004
##   3   0.012
##   1   0.004
##   2   0.008
##   1   0.004
##   1   0.004
##   1   0.004
##   2   0.008
```

# Revenue?


```r
GDPT <- gdpr_violations %>% group_by(name) %>% summarise(Collected = sum(price), Violations = n())
GDPT %>% select(name, Collected) %>% ggplot(., aes(x=fct_reorder(name, Collected), y=Collected/1e7, fill=name)) + geom_col() + scale_fill_viridis_d() + coord_flip() + labs(x="Country", y="Total Fines Collected (in Millions)") + guides(fill=FALSE)
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-4-1.png" width="672" />

# A Map


```r
library(rnaturalearth)
Europe <- ne_countries(scale = 'medium', type = 'map_units', returnclass = 'sf', continent="Europe")
library(sf)
```

```
## Linking to GEOS 3.8.1, GDAL 3.1.4, PROJ 6.3.1
```

```r
Europe <- sf::st_crop(Europe, xmin = -20, xmax = 45, ymin = 30, ymax = 73)
```

```
## although coordinates are longitude/latitude, st_intersection assumes that they are planar
```

```
## Warning: attribute variables are assumed to be spatially constant throughout all
## geometries
```

```r
ggplot(Europe) + geom_sf()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-5-1.png" width="672" />

## Merge Data

Plot some Europe Maps.

## Total Collections


```r
Map.Me <- left_join(Europe, GDPT, by = c("sovereignt" = "name"))
ggplot(Map.Me) + aes(fill=Collected) + geom_sf() + scale_fill_viridis_c()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-6-1.png" width="672" />

## Count of Violations


```r
ggplot(Map.Me) + aes(fill=Violations) + geom_sf() + scale_fill_viridis_c()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-7-1.png" width="672" />

## Cost per violation


```r
Map.Me %>% mutate(Avg.Fine = Collected / Violations) %>% ggplot(.) + aes(fill=Avg.Fine) + geom_sf() + labs(title="Average Fine per Violation") + scale_fill_viridis_c()
```

<img src="{{< blogdown/postref >}}index_files/figure-html/unnamed-chunk-8-1.png" width="672" />

