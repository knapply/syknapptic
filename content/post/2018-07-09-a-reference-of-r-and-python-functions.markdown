---
title: A Field Guide to R-Python Translations
draft: false
author: Brendan Knapp
date: '2018-07-09'
slug: reticulated-python
categories: 
  - data-science-from-scratch
tags:
  - reticulated-python
thumbnailImage: https://raw.githubusercontent.com/syknapptic/RversusPython/master/README_image.JPG
metaAlignment: center
summary: A work in progress.
output:
  # html_document:
  blogdown::html_page:
    toc: true
    toc_depth: 3
editor_options: 
  chunk_output_type: console
---



<img src="https://raw.githubusercontent.com/syknapptic/RversusPython/master/README_image.JPG" style="display: block; margin: auto;" />

# Types

<table class="table" style="font-size: 14px; width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> Python Type </th>
   <th style="text-align:left;"> Python Example </th>
   <th style="text-align:left;"> R Type </th>
   <th style="text-align:left;"> R Example </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: red;">int</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: red;">1</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: blue;">integer</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: blue;">1L</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: red;">float</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: red;">3.14</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: blue;">numeric &amp; double</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: blue;">3.14</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: red;">string</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: red;">'hi'</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: blue;">character</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: blue;">"hi"</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: red;">bool</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: red;">True</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: blue;">logical</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: blue;">TRUE</span> </td>
  </tr>
</tbody>
</table>

# Collections

<table class="table" style="font-size: 14px; width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> Python Type </th>
   <th style="text-align:left;"> Python Example </th>
   <th style="text-align:left;"> R Type </th>
   <th style="text-align:left;"> R Example </th>
   <th style="text-align:left;"> Values </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: red;">scalar</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: red;">1</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: blue;">vector</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: blue;">1</span> </td>
   <td style="text-align:left;"> <span style="     color: green;">homogeneous</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: red;">list</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: red;">[1, 1]</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: blue;">vector</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: blue;">c(1, 2)</span> </td>
   <td style="text-align:left;"> <span style="     color: green;">homogeneous</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: red;">list</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: red;">[1, 'string']</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: blue;">list</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: blue;">list(1, "string")</span> </td>
   <td style="text-align:left;"> <span style="     color: purple;">heterogenous</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: red;">tuple</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: red;">(1, 'string']</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: blue;">list</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: blue;">list(1, "string")</span> </td>
   <td style="text-align:left;"> <span style="     color: purple;">heterogenous</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: red;">dict</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: red;">{'a':1, 'b':'string'}</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: blue;">list</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: blue;">list(a = 1, b = "string")</span> </td>
   <td style="text-align:left;"> <span style="     color: purple;">heterogenous</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;">  </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: blue;">vector</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: blue;">c(a = 1, b = 2)</span> </td>
   <td style="text-align:left;"> <span style="     color: green;">homogeneous</span> </td>
  </tr>
</tbody>
</table>

# Comparisons

<table class="table" style="font-size: 14px; width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> Python </th>
   <th style="text-align:left;"> R </th>
   <th style="text-align:left;"> Meaning </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: red;">&lt;</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: blue;">&lt;</span> </td>
   <td style="text-align:left;"> <span style="     color: green;">less than</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: red;">&gt;</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: blue;">&gt;</span> </td>
   <td style="text-align:left;"> <span style="     color: green;">greater than</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: red;">&lt;=</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: blue;">&lt;=</span> </td>
   <td style="text-align:left;"> <span style="     color: green;">less than or equal</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: red;">&gt;=</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: blue;">&gt;=</span> </td>
   <td style="text-align:left;"> <span style="     color: green;">greater than or equal</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: red;">==</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: blue;">==</span> </td>
   <td style="text-align:left;"> <span style="     color: green;">is equal</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: red;">!=</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: blue;">!=</span> </td>
   <td style="text-align:left;"> <span style="     color: green;">is not equal</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: red;">is &lt;SOMETHING&gt;</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: blue;">is.&lt;SOMETHING&gt; | is_&lt;SOMETHING&gt;</span> </td>
   <td style="text-align:left;"> <span style="     color: green;">is an object &lt;SOMETHING&gt;</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: red;">is not &lt;SOMETHING&gt;</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: blue;">!is.&lt;SOMETHING&gt; | !is_&lt;SOMETHING&gt;</span> </td>
   <td style="text-align:left;"> <span style="     color: green;">is an object not &lt;SOMETHING&gt;</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: red;">and</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: blue;">&amp;</span> </td>
   <td style="text-align:left;"> <span style="     color: green;">and</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: red;">or</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: blue;">|</span> </td>
   <td style="text-align:left;"> <span style="     color: green;">or</span> </td>
  </tr>
</tbody>
</table>

# Arithmetic

<table class="table" style="font-size: 14px; width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> Python </th>
   <th style="text-align:left;"> R </th>
   <th style="text-align:left;"> Meaning </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: red;">x + y</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: blue;">x + x</span> </td>
   <td style="text-align:left;"> <span style="     color: green;">x <span style=" font-weight: bold;    ">P</span><span style=" font-weight: bold;    ">L</span><span style=" font-weight: bold;    ">U</span><span style=" font-weight: bold;    ">S</span> y</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: red;">x - y</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: blue;">x - y</span> </td>
   <td style="text-align:left;"> <span style="     color: green;">x <span style=" font-weight: bold;    ">M</span><span style=" font-weight: bold;    ">I</span><span style=" font-weight: bold;    ">N</span><span style=" font-weight: bold;    ">U</span><span style=" font-weight: bold;    ">S</span> y</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: red;">x * y</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: blue;">x * y</span> </td>
   <td style="text-align:left;"> <span style="     color: green;">x <span style=" font-weight: bold;    ">T</span><span style=" font-weight: bold;    ">I</span><span style=" font-weight: bold;    ">M</span><span style=" font-weight: bold;    ">E</span><span style=" font-weight: bold;    ">S</span> y</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: red;">x / y</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: blue;">x / y</span> </td>
   <td style="text-align:left;"> <span style="     color: green;">x <span style=" font-weight: bold;    ">D</span><span style=" font-weight: bold;    ">I</span><span style=" font-weight: bold;    ">V</span><span style=" font-weight: bold;    ">I</span><span style=" font-weight: bold;    ">D</span><span style=" font-weight: bold;    ">E</span><span style=" font-weight: bold;    ">D</span> <span style=" font-weight: bold;    ">B</span><span style=" font-weight: bold;    ">Y</span> y</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: red;">x // y</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: blue;">x %/% y</span> </td>
   <td style="text-align:left;"> <span style="     color: green;"><span style=" font-weight: bold;    ">F</span><span style=" font-weight: bold;    ">L</span><span style=" font-weight: bold;    ">O</span><span style=" font-weight: bold;    ">O</span><span style=" font-weight: bold;    ">R</span><span style=" font-weight: bold;    ">E</span><span style=" font-weight: bold;    ">D</span> <span style=" font-weight: bold;    ">Q</span><span style=" font-weight: bold;    ">U</span><span style=" font-weight: bold;    ">O</span><span style=" font-weight: bold;    ">T</span><span style=" font-weight: bold;    ">I</span><span style=" font-weight: bold;    ">E</span><span style=" font-weight: bold;    ">N</span><span style=" font-weight: bold;    ">T</span> <span style=" font-weight: bold;    ">O</span><span style=" font-weight: bold;    ">F</span> x <span style=" font-weight: bold;    ">D</span><span style=" font-weight: bold;    ">I</span><span style=" font-weight: bold;    ">V</span><span style=" font-weight: bold;    ">I</span><span style=" font-weight: bold;    ">D</span><span style=" font-weight: bold;    ">E</span><span style=" font-weight: bold;    ">D</span> <span style=" font-weight: bold;    ">B</span><span style=" font-weight: bold;    ">Y</span> y</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: red;">x % y</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: blue;">x %% y</span> </td>
   <td style="text-align:left;"> <span style="     color: green;"><span style=" font-weight: bold;    ">R</span><span style=" font-weight: bold;    ">E</span><span style=" font-weight: bold;    ">M</span><span style=" font-weight: bold;    ">A</span><span style=" font-weight: bold;    ">I</span><span style=" font-weight: bold;    ">N</span><span style=" font-weight: bold;    ">D</span><span style=" font-weight: bold;    ">E</span><span style=" font-weight: bold;    ">R</span> <span style=" font-weight: bold;    ">O</span><span style=" font-weight: bold;    ">F</span> x <span style=" font-weight: bold;    ">D</span><span style=" font-weight: bold;    ">I</span><span style=" font-weight: bold;    ">V</span><span style=" font-weight: bold;    ">I</span><span style=" font-weight: bold;    ">D</span><span style=" font-weight: bold;    ">E</span><span style=" font-weight: bold;    ">D</span> <span style=" font-weight: bold;    ">B</span><span style=" font-weight: bold;    ">Y</span> y</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: red;">-x</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: blue;">-x</span> </td>
   <td style="text-align:left;"> <span style="     color: green;"><span style=" font-weight: bold;    ">N</span><span style=" font-weight: bold;    ">E</span><span style=" font-weight: bold;    ">G</span><span style=" font-weight: bold;    ">A</span><span style=" font-weight: bold;    ">T</span><span style=" font-weight: bold;    ">I</span><span style=" font-weight: bold;    ">V</span><span style=" font-weight: bold;    ">E</span> x</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: red;">x**y</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: blue;">x^y</span> </td>
   <td style="text-align:left;"> <span style="     color: green;">x <span style=" font-weight: bold;    ">R</span><span style=" font-weight: bold;    ">A</span><span style=" font-weight: bold;    ">I</span><span style=" font-weight: bold;    ">S</span><span style=" font-weight: bold;    ">E</span><span style=" font-weight: bold;    ">D</span> <span style=" font-weight: bold;    ">T</span><span style=" font-weight: bold;    ">O</span> <span style=" font-weight: bold;    ">T</span><span style=" font-weight: bold;    ">H</span><span style=" font-weight: bold;    ">E</span> <span style=" font-weight: bold;    ">P</span><span style=" font-weight: bold;    ">O</span><span style=" font-weight: bold;    ">W</span><span style=" font-weight: bold;    ">E</span><span style=" font-weight: bold;    ">R</span> <span style=" font-weight: bold;    ">O</span><span style=" font-weight: bold;    ">F</span> y</span> </td>
  </tr>
</tbody>
</table>


# Dates and Times

<table class="table" style="font-size: 14px; width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> Python </th>
   <th style="text-align:left;"> R </th>
   <th style="text-align:left;"> Result </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: red;">import datetime</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: blue;">library(lubridate)</span> </td>
   <td style="text-align:left;"> <span style="     color: green;">relevant packages are imported</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: red;"></span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: blue;"></span> </td>
   <td style="text-align:left;"> <span style="     color: green;"></span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: red;">right_now = datetime.today()</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: blue;">right_now &lt;- now()</span> </td>
   <td style="text-align:left;"> <span style="     color: green;">current date and time</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: red;">right_now.year</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: blue;">year(right_now)</span> </td>
   <td style="text-align:left;"> <span style="     color: green;">current <span style=" font-weight: bold;    ">year</span></span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: red;">right_now.month</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: blue;">month(right_now)</span> </td>
   <td style="text-align:left;"> <span style="     color: green;"><span style=" font-weight: bold;    ">month</span> of the year</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: red;">right_now.isocalendar()[1]</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: blue;">week(right_now)</span> </td>
   <td style="text-align:left;"> <span style="     color: green;"><span style=" font-weight: bold;    ">week</span> of the year</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: red;">right_now.day</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: blue;">day(right_now)</span> </td>
   <td style="text-align:left;"> <span style="     color: green;"><span style=" font-weight: bold;    ">day</span> of the month</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: red;">right_now.hour</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: blue;">hour(right_now)</span> </td>
   <td style="text-align:left;"> <span style="     color: green;"><span style=" font-weight: bold;    ">hour</span> of the day</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: red;">right_now.minute</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: blue;">minute(right_now)</span> </td>
   <td style="text-align:left;"> <span style="     color: green;"><span style=" font-weight: bold;    ">minute</span> of the hour</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: red;">right_now.second</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: blue;">second(right_now)</span> </td>
   <td style="text-align:left;"> <span style="     color: green;"><span style=" font-weight: bold;    ">second</span> of the minute</span> </td>
  </tr>
</tbody>
</table>

# URLs

<table class="table" style="font-size: 14px; width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:left;"> Python </th>
   <th style="text-align:left;"> R </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: red;">from urllib.request import urlretrieve</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: blue;">_</span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: red;"></span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: blue;"></span> </td>
  </tr>
  <tr>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: red;">urlrequest(&lt;url&gt;, &lt;destination&gt;)</span> </td>
   <td style="text-align:left;"> <span style="   font-family: monospace;  color: blue;">download.file(&lt;url&gt;, &lt;destination&gt;)</span> </td>
  </tr>
</tbody>
</table>

