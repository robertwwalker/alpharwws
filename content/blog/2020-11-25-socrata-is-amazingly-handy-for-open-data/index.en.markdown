---
title: Socrata is amazingly handy for open data
authors: ["RWW"]
date: '2020-11-25'
slug: socrata-is-amazingly-handy-for-open-data
categories:
  - R
tags: []
subtitle: ''
summary: ''
lastmod: '2020-11-25T13:16:28-08:00'
featured: no
image:
  caption: ''
  focal_point: ''
  preview_only: no
projects: []
---

<script src="{{< blogdown/postref >}}index.en_files/kePrint/kePrint.js"></script>
<link href="{{< blogdown/postref >}}index.en_files/lightable/lightable.css" rel="stylesheet" />
<script src="{{< blogdown/postref >}}index.en_files/htmlwidgets/htmlwidgets.js"></script>
<script src="{{< blogdown/postref >}}index.en_files/pymjs/pym.v1.js"></script>
<script src="{{< blogdown/postref >}}index.en_files/widgetframe-binding/widgetframe.js"></script>

The Socrata package makes it easy to access API calls built around SODA for open data access. If you try to skip the Socrata part, you usually only get a fraction of the available data. Socrata is intended to make open access data easier to manage and many government entities in the US use it as the portal to public data access. The R package makes interfacing with it much easier. First, how can we install it? It is on CRAN.

    install.packages("RSocrata")
    library(RSocrata)
    SchoolSpend <- read.socrata("https://data.oregon.gov/resource/c7av-ntdz.csv")

The first bit of data that I found details various bits about spending and students in Oregon school districts. I want to look at a few basics of this. There is a lot more to plot but this is enough for now.

## The Data

I found this on Oregon’s open data portal. What do I have?

``` r
library(skimr)
skim(SchoolSpend) %>% kable() %>% scroll_box(width="100%")
```

<div style="border: 1px solid #ddd; padding: 5px; overflow-x: scroll; width:100%; ">

<table>
<thead>
<tr>
<th style="text-align:left;">
skim\_type
</th>
<th style="text-align:left;">
skim\_variable
</th>
<th style="text-align:right;">
n\_missing
</th>
<th style="text-align:right;">
complete\_rate
</th>
<th style="text-align:right;">
character.min
</th>
<th style="text-align:right;">
character.max
</th>
<th style="text-align:right;">
character.empty
</th>
<th style="text-align:right;">
character.n\_unique
</th>
<th style="text-align:right;">
character.whitespace
</th>
<th style="text-align:right;">
numeric.mean
</th>
<th style="text-align:right;">
numeric.sd
</th>
<th style="text-align:right;">
numeric.p0
</th>
<th style="text-align:right;">
numeric.p25
</th>
<th style="text-align:right;">
numeric.p50
</th>
<th style="text-align:right;">
numeric.p75
</th>
<th style="text-align:right;">
numeric.p100
</th>
<th style="text-align:left;">
numeric.hist
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
character
</td>
<td style="text-align:left;">
county\_name
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
4
</td>
<td style="text-align:right;">
10
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
36
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:left;">
NA
</td>
</tr>
<tr>
<td style="text-align:left;">
character
</td>
<td style="text-align:left;">
district\_number
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
9
</td>
<td style="text-align:right;">
33
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
375
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:left;">
NA
</td>
</tr>
<tr>
<td style="text-align:left;">
character
</td>
<td style="text-align:left;">
school\_year
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
10
</td>
<td style="text-align:right;">
10
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
13
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:left;">
NA
</td>
</tr>
<tr>
<td style="text-align:left;">
numeric
</td>
<td style="text-align:left;">
district\_id
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
2094.940
</td>
<td style="text-align:right;">
189.4799
</td>
<td style="text-align:right;">
1894.0
</td>
<td style="text-align:right;">
1999.00
</td>
<td style="text-align:right;">
2085.00
</td>
<td style="text-align:right;">
2190.00
</td>
<td style="text-align:right;">
4131.00
</td>
<td style="text-align:left;">
▇▁▁▁▁
</td>
</tr>
<tr>
<td style="text-align:left;">
numeric
</td>
<td style="text-align:left;">
operating\_cost\_per\_student
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
10337.758
</td>
<td style="text-align:right;">
7762.8027
</td>
<td style="text-align:right;">
0.0
</td>
<td style="text-align:right;">
7252.19
</td>
<td style="text-align:right;">
8596.27
</td>
<td style="text-align:right;">
10797.39
</td>
<td style="text-align:right;">
170210.60
</td>
<td style="text-align:left;">
▇▁▁▁▁
</td>
</tr>
<tr>
<td style="text-align:left;">
numeric
</td>
<td style="text-align:left;">
student\_count
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
2900.144
</td>
<td style="text-align:right;">
6105.8332
</td>
<td style="text-align:right;">
0.0
</td>
<td style="text-align:right;">
234.00
</td>
<td style="text-align:right;">
872.00
</td>
<td style="text-align:right;">
2934.00
</td>
<td style="text-align:right;">
55321.00
</td>
<td style="text-align:left;">
▇▁▁▁▁
</td>
</tr>
<tr>
<td style="text-align:left;">
numeric
</td>
<td style="text-align:left;">
state\_student\_count
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
552475.185
</td>
<td style="text-align:right;">
5910.9535
</td>
<td style="text-align:right;">
539105.0
</td>
<td style="text-align:right;">
549169.00
</td>
<td style="text-align:right;">
552161.00
</td>
<td style="text-align:right;">
558366.00
</td>
<td style="text-align:right;">
561354.00
</td>
<td style="text-align:left;">
▂▂▇▃▆
</td>
</tr>
<tr>
<td style="text-align:left;">
numeric
</td>
<td style="text-align:left;">
operating\_cost
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
22756620.867
</td>
<td style="text-align:right;">
49527514.3895
</td>
<td style="text-align:right;">
9881.0
</td>
<td style="text-align:right;">
2458166.78
</td>
<td style="text-align:right;">
7089257.97
</td>
<td style="text-align:right;">
22617257.11
</td>
<td style="text-align:right;">
513891919\.14
</td>
<td style="text-align:left;">
▇▁▁▁▁
</td>
</tr>
<tr>
<td style="text-align:left;">
numeric
</td>
<td style="text-align:left;">
state\_operating\_cost
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
4337006498.569
</td>
<td style="text-align:right;">
697307559\.8432
</td>
<td style="text-align:right;">
948447366\.8
</td>
<td style="text-align:right;">
3889552066.13
</td>
<td style="text-align:right;">
4198534676.94
</td>
<td style="text-align:right;">
5144636555.37
</td>
<td style="text-align:right;">
5248233458.10
</td>
<td style="text-align:left;">
▁▁▁▇▆
</td>
</tr>
<tr>
<td style="text-align:left;">
numeric
</td>
<td style="text-align:left;">
state\_operating\_cost\_per\_student
</td>
<td style="text-align:right;">
0
</td>
<td style="text-align:right;">
1
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
NA
</td>
<td style="text-align:right;">
7839.076
</td>
<td style="text-align:right;">
1195.0422
</td>
<td style="text-align:right;">
1759.3
</td>
<td style="text-align:right;">
7044.24
</td>
<td style="text-align:right;">
7636.57
</td>
<td style="text-align:right;">
9164.69
</td>
<td style="text-align:right;">
9384.06
</td>
<td style="text-align:left;">
▁▁▁▇▆
</td>
</tr>
</tbody>
</table>

</div>

## How many school districts per county?

``` r
library(magrittr); library(hrbrthemes)
SchoolSpend %>% group_by(county_name, school_year) %>% tally() %>% mutate(school_year = as.Date(school_year, format = "%m/%d/%Y")) %>% filter(school_year == max(school_year)) %>% ggplot() + aes(x=fct_reorder(county_name, n), y=n, fill=county_name) + geom_col() + coord_flip() + guides(fill=FALSE) + labs(x= "County", y="Number of School Districts") + theme_minimal()
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-2-1.png" width="672" />

## By Students?

``` r
SchoolSpend %>% group_by(county_name) %>% mutate(school_year = as.Date(school_year, format = "%m/%d/%Y")) %>% filter(school_year == max(school_year)) %>% summarise(Students = sum(student_count), Year = mean(school_year), County = as.factor(county_name)) %>% unique() -> Dat
ggplot(Dat) + aes(x=fct_reorder(County, -Students), y=Students, fill=county_name) + geom_col() + coord_flip() + guides(fill=FALSE) + labs(x= "County", y="Students") + theme_minimal()
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-3-1.png" width="672" />

There are a number of other bits of data organized by year and district. There is certainly more to examine, but then I found this.

# Voter Registration Data

The database of Voter Registrations in Oregon is also available and easily accessible.

``` r
VoterReg <- read.socrata("https://data.oregon.gov/resource/6a4f-ecbi.csv")
VoterReg %>% filter(sysdate == "2020-11-03") %>% group_by(county) %>% summarise(Voters = sum(count_v_id)) %>% ggplot(., aes(x=fct_reorder(county, Voters), y=Voters, label=Voters)) + geom_col(fill="white", color="skyblue") + geom_text(size=2.2) + coord_flip() + labs(x="County", y="Registered Voters") + theme_minimal() -> Plot1
Plot1
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-4-1.png" width="672" />

``` r
library(plotly); library(widgetframe)
ggp1 <- ggplotly(Plot1)
frameWidget(ggp1)
```

<div id="htmlwidget-1" style="width:100%;height:480px;" class="widgetframe html-widget"></div>
<script type="application/json" data-for="htmlwidget-1">{"x":{"url":"index.en_files/figure-html//widgets/widget_Plotly1.html","options":{"xdomain":"*","allowfullscreen":false,"lazyload":false}},"evals":[],"jsHooks":[]}</script>

## The Balance of Registrations

``` r
CurrVR <- VoterReg %>% filter(sysdate == "2020-11-03")
CurrVR$DRE <- "Other"
CurrVR$DRE[CurrVR$party=="Democrat"] <- "Democrat"
CurrVR$DRE[CurrVR$party=="Republican"] <- "Republican"
CurrVR %>% group_by(county) %>% mutate(Voters = sum(count_v_id)) %>% ggplot(., aes(x=fct_reorder(county, Voters), y=Voters, label=Voters)) + geom_col() + geom_text(size=2.2) + coord_flip() + labs(x="County", y="Registered Voters") + theme_minimal()
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-5-1.png" width="672" />

## The Plot by Party

Now let me split these up by grouping and plot them.

``` r
CurrVR %>% group_by(county, DRE) %>% summarise(Voters = sum(count_v_id)) %>%
ggplot(.) +
 aes(x = fct_reorder(county, Voters), y=Voters, fill = DRE) +
 geom_col() + scale_fill_viridis_d() +
 coord_flip() +
 theme_minimal() + labs(x="County")
```

<img src="{{< blogdown/postref >}}index.en_files/figure-html/unnamed-chunk-6-1.png" width="672" />
