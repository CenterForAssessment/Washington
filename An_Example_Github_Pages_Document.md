---
layout: report
report_title: An Example Github Pages Document
report_abstract: Here is some text about the document - something like an abstract ... Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur lobortis lectus et tellus pharetra sodales. Duis eget sapien quis urna sagittis facilisis. Ut aliquam dui ut est euismod a mattis magna semper. Curabitur nec magna turpis. Etiam suscipit lectus vel lacus dignissim sollicitudin non at nisi. Proin ut nibh non magna vulputate laoreet in eget felis. Vivamus eget turpis nulla. Aliquam erat volutpat. Suspendisse potenti. Nullam viverra diam sit amet risus fermentum iaculis. Integer vitae purus eu urna ultrices sodales vel sed nisl. Cras lorem est, ultrices sed vulputate in, mattis ac justo.
report_date: June 2013
meta_title: Github Document
meta_subtitle: Lorem ipsum
contents:
  - section: Introduction
    subsections: [Lists and YAML Front Matter, Long Section Names]
  - section: Equations and Tables
    subsections: [Mathematical Equations, Markdown Tables, LaTeX Tables, HTML Tables]
  - section: Figures and Charts
    subsections: [Static Figures, Images from the Web, Interactive D3 Charts]
  - section: References
---

# Introduction
This Github repository provides a template for transforming a simple markdown text file into a nice looking HTML document by using Jekyll. Because Github supports Jekyll, this document can be hosted as a static website for free through [Github pages](http://pages.github.com/).  You are now looking at the sample version of this document, which includes text (including lists, sections, subsections and sub-subsections), as well as tables and figures of varying levels of sophistication.  Some examples use HTML code integrated directly into the markdown text file, but when possible I have provided simple markdown analogues.  As would be expected, a more detailed document requires more detailed code ...

##  Lists and YAML Front Matter
This section provides an example of how to form basic lists and and also provides an explanation of the YAML front matter required to produce this document.  What in the world is YAML front matter, you ask?  [Read this](http://en.wikipedia.org/wiki/YAML) for a general information and [this article](http://jekyllrb.com/docs/frontmatter/) for an explanation of how Jekyll (and Liquid) use it to produce static websites.  YAML front matter is located at the very top of the [index.md](https://raw.github.com/adamvi/Markdown_Document/gh-pages/index.md) file.  It is composed of several variables sandwiched between triple dashes (`---`). These variables define how your Markdown Document will appear and will require some customization by you the author.

1.  **"layout"** - this corresponds to the *.html file you want to use as the 'layout' for your document.  Two choices are provided here in the `_layouts/` directory.  The first is report.html, which is the more detailed document that includes the "document lens" navigation tool on the left hand side of the static website.  The other layout template is report_simple.html, which provides only the formatted document.  It allows one to print out a clean version of the document, and may be more easily read on mobile devices.  This version [can be viewed here](An_Example_Github_Pages_Document_Simple.html), although a link for it can also be found at the bottom of the document lens.  The markdown file used to create it is identical to index.md, but with the revised YAML entry for 'layout' and has the 'contents' area removed from it.  The raw version of the markdown text file can be [viewed on Github](https://raw.github.com/adamvi/Markdown_Document/gh-pages/An_Example_Github_Pages_Document_Simple.md).
2.  **"report_title"** - This is the printed title at the top of the document.  It is also the name that must be given (words separated by underscores) to both the pdf version of the report for download and the .md file used for the simple (printable) version.  Links for these items are created as a default.
3.  **"report_abstract"** - this is the blurb that (can) appear underneath the document tittle.
4.  **"report_date"** - the date the report/document was published
5.  **"meta_title"** - The informational title that appears on the web-browser tab that the page is displayed in. 
6.  **"meta_subtitle"** - The informational subtitle that appears on the web-browser tab.  Separated from the meta title by a colon (:).
7.  **"contents"** - These are the document content descriptors that create the "document lens" navigation tool on the left hand side of the static website.  This is a compound YAML entry that is comprised of two components:
    1. ***"sections"*** - the 'header 1' in markdown and/or 'h1' in html (sections beginning with single # marks)
	2. ***"subsections"*** - the 'header 2' in markdown and/or 'h2' in html (double # marks)

*  **NOTE.**  The sections and subsections provided in the **"contents"** must be IDENTICAL to the actual section names in order to produce the link to the (sub)section.  However, one can provide an alternate name in the document lens with the use of direct HTML coding.  See the following section [Long Section Names](#long-section-names) for more details: 
*  **NOTE.**  Although HTML has up to 6 headers (h6), only the first 2 are currently supported in the "Document Lens"
*  **NOTE.**  Did you notice that these **Notes** are a totally separate list than the numbered one above?  *GROOVY...*

## Long section names can be shortened in the document navigation lens ... <a id="long-section-names">
Shortened header names can be included in the document navigation lens (left side of page) by using HTML id code added to the header line.  For example, this h2 subsection is referred to as simply "Long Section Names" in both the YAML front matter and the document navigation.  The header line is given in the markdown document as 

`## Long section names can be shortened in the document navigation lens ... <a id="long-section-names">`.

### Sub-Sub Sections
Third level sections get included in the section numbering system (here 1.2.1), but the DO NOT get included in the "Document Lens" navigation.

### Curabitur sodales ligula in libero
Sed dignissim lacinia nunc. Curabitur tortor. Pellentesque nibh. Aenean quam. In scelerisque sem at dolor. Maecenas mattis. Sed convallis tristique sem. Proin ut ligula vel nunc egestas porttitor. Morbi lectus risus, iaculis vel, suscipit quis, luctus non, massa. Fusce ac turpis quis ligula lacinia aliquet. Mauris ipsum. Nulla metus metus, ullamcorper vel, tincidunt sed, euismod in, nibh. Quisque volutpat condimentum velit. 

# Equations and Tables
This document includes some pretty fine features, including the ability to render math equations, tables and figures.  I use the kramdown flavor of markdown to allow for LaTeX style math formulas (with the use of MathJax).  LaTeX tables can also be rendered if one treats an 'array' as a math equation.  Unfortunately some of the nice features available in the tabular environment are not available in array (e.g. the `\multicolumn` feature).

There are three types of table examples provided in this section.  The degree of sophistication and difficulty increases from basic markdown tables to LaTeX and bona-fide HTML script included directly within the markdown text document.

## Mathematical Equations
When "kramdown" flavor of Markdown is specified in the _config.yml file, it is possible to produce beautiful equations, either inline or as a separate "display" line.  Equations are written in LaTeX, interpreted into HTML by MathJax.  For example, to include an inline LaTeX equation you enclose the code in $ delimiters.  For example, this code `$\frac{1}{n} \sum_{i=1}^{n} x_{i}$` for the arithmetic mean produces this $\frac{1}{n} \sum _{i=1}^{n} x _{i}$ inline equation.  Other, more complex or important, equations may need their own line, or "display".  Displayed equations are also numbered according to the order of presentation.  For example:

$$ MSE = \frac{1}{n} \sum_ {i=1}^n (\widehat{\theta}_ {i} - \theta_i)^2$$

$$ MSE(\hat{\theta}) = \mathbb{E}[(\hat{\theta} - \theta)^2]$$

## Markdown Tables
The nicest example tables are provided using raw HTML in subsequent sections.  This, however, sucks and kinda defeats the purpose of using markdown to begin with.  This section provides a simple example of a table produced in 'pure' markdown.    None of these options seem great to me, so if you have a better (i.e. 'pure' markdown) solution please let me know by forking this repository and a placing a pull request, or by adding an [issue](https://github.com/adamvi/Markdown_Document/issues).

### Basic Markdown Tables
There are many simple examples of markdown tables.  A cheat-sheet for this and other good stuff can be [found on this page](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet#tables).  Here are their examples:

Colons can be used to align columns.

| Tables        | Are           | Cool  |
| ------------- |:-------------:| -----:|
| col 3 is      | right-aligned | $1600 |
| col 2 is      | centered      |   $12 |
| zebra stripes | are neat      |    $1 |

The outer pipes (`|`) are optional, and you don't need to make the raw Markdown line up prettily. You can also use inline Markdown.

Markdown | Less | Pretty
--- | --- | ---
*Still* | `renders` | **nicely**
1 | 2 | 3

### Complex Markdown Tables

Here is an attempt I made at making a more complex markdown table using separators to mark two main sections of the table (**Aliquam Leo Lorem** and **Aliquam Leo Nibh**).  Multiple column spanning is not possible, so I try to place and align columns as best as possible.

|----------------------+-------------+-------------+-------------+-------------+---------------+-------------|
|***Table 1.***        |             |             |             |             |               |             |
|                      |             | **Aliquam Leo Lorem** |       |         |      | **Aliquam Leo Nibh** |
|:---------------------|------------:|------------:|------------:|------------:|--------------:|------------:|
|                      |...............|............................|...............|      |       |         |
|                      |  Nec Nibh   |  Ultricies  | Cras Purus  |   Nec Nibh  | Ultricies   |  Cras Purus   |
| Pellentesque         |   362.980   |    0.019    |    False    |   393.244   |   -0.107    |       True    |
| Pellentesque Nec     |   360.795   |   -0.001    |    True     |   379.277   |    0.088    |      False    |
|----------------------+-------------+-------------+-------------+-------------+---------------+-------------|

Fusce ac turpis quis ligula lacinia aliquet. Mauris ipsum. Nulla metus metus, ullamcorper vel, tincidunt sed, euismod in, nibh. Quisque volutpat condimentum velit. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Nam nec ante. Sed lacinia, urna non tincidunt mattis, tortor neque adipiscing diam, a cursus ipsum ante quis turpis. Nulla facilisi. Ut fringilla. Suspendisse potenti. Nunc feugiat mi a tellus consequat imperdiet. Vestibulum sapien. 

## LaTeX Tables
Tables can also be produced using the LaTeX "array" environment.  An array can be rendered as a table when presented as math code.  Although array is a math mode analog to the tabular environment, some of the functionality of tabular is unavailable in array.  For example, Table 3 would require the use of '\multicolumn' to do the job of HTML codes 'colspan'.  Here is some [documentation about LaTeX arrays](http://www.maths.tcd.ie/~dwilkins/LaTeXPrimer/Matrices.html).

Like [display LaTeX math functions](http://www.rstudio.com/ide/docs/authoring/using_markdown_equations), the array is enclosed by double dollar sign, `$$`, in the markdown text. Here is an example of a simple LaTeX array used in markdown.

**Table 4.  Disply Math Function (Centered, but puts equation number in)**

$$
\begin{array}{lcr}
\textbf{What} & \textbf{Variable} & \textbf{Integer}\\
\mbox{First number} & x & 8\\
\mbox{Second number} & y & 15\\
\mbox{Sum} & x + y & 23\\
\mbox{Difference} & x - y & -7\\
\mbox{Product} & xy & 120 \end{array}
$$

[Inline LaTeX](http://www.rstudio.com/ide/docs/authoring/using_markdown_equations) can also be used.  Here the array is enclosed in single `$` in the markdown text.

**Table 5.  Inline Math Function (Alligned Left, requires quadruple backslashes for 'end line')**

$\begin{array}{lcr} \textbf{What} & \textbf{Variable} & \textbf{Integer}\\\\\mbox{First Number} & x & 8\\\\\mbox{Second Number} & y & 15\\\\\mbox{Sum} & x+y & 23\\\\\mbox{Difference}&  x-y & -7\\\\\mbox{Product} & xy & 120 \end{array}$

Etiam ultrices. Suspendisse in justo eu magna luctus suscipit. Sed lectus. Integer euismod lacus luctus magna. Quisque cursus, metus vitae pharetra auctor, sem massa mattis sem, at interdum magna augue eget diam. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Morbi lacinia molestie dui. Praesent blandit dolor. Sed non quam. In vel mi sit amet augue congue elementum. Morbi in ipsum sit amet pede facilisis laoreet. 

## HTML Tables

As I have mentioned, HTML tables are potentially more flexible, beautiful and awesome than either LaTeX or Markdown tables.  But they make me want to cry when I see the code and/or try to interpret.  I wish they were easier to produce and read, but they are not.  It may defeat the purpose of using markdown to begin with slightly, but at least the option exists.

###  First HTML Example Table

<!--  Markdown Version of Table 2
|----------------------+-------------+-------------+-------------+-------------+---------------+-------------|
|**Table 2.**          |             |             |             |             |            | Varius Nec Nibh|
|                      |             | Aliquam Leo Lorem |       |             |           | Vel Ultricies Eu|
|:---------------------|------------:|------------:|------------:|------------:|--------------:|------------:|
|                      |...............|............................|...............|      |       |         |
|                      | Nec Nibh   |  Ultricies   |  Cras Purus |  Nec Nibh   |   Ultricies   |  Cras Purus |
| Pellentesque         |   362.980   |    0.019    |     8.004   |   248.836   |     -0.428    |     5.652   |
| Pellentesque Nec     |   360.795   |   -0.001    |     7.512   |   287.078   |     -0.057    |     6.225   |
|----------------------+-------------+-------------+-------------+-------------+---------------+-------------|
-->

**Table 2.  A Table Produced Using HTML Code Directly within the Document**
<div>
<table class='gmisc_table' style='border-collapse: collapse;'>
    <a name='Table 2.'></a>
    <thead>
    <tr>
        <th style='font-weight: 900; border-top: 4px double grey;'></th>
        <th align='center' colspan='3' style='font-weight: 900; border-bottom: 1px solid grey; border-top: 4px double grey;'>Aliquam Leo Lorem</th><th style='border-top: 4px double grey;'>&nbsp;</th>
        <th align='center' colspan='3' style='font-weight: 900; border-bottom: 1px solid grey; border-top: 4px double grey;'>Aliquam Leo Nibh</th>
    </tr>
    <tr>
        <th style=';'>&nbsp;</th>
        <th align='center' style='border-bottom: 1px solid grey;'>Nec Nibh</th>
        <th align='center' style='border-bottom: 1px solid grey;'>Ultricies</th>
        <th align='center' style='border-bottom: 1px solid grey;'>Cras Purus</th>
        <th style='border-bottom: 1px solid grey;'>&nbsp;</th>
        <th align='center' style='border-bottom: 1px solid grey;'>Nec Nibh</th>
        <th align='center' style='border-bottom: 1px solid grey;'>Ultricies</th>
        <th align='center' style='border-bottom: 1px solid grey;'>Cras Purus</th>
    </tr>
    </thead><tbody>
    <tr><td align='left' style='border-bottom: 1px solid grey; font-weight: 900;'>Analysis</td></tr>
    <tr>
        <td align='right' style=';'>Pellentesque</td>
        <td align='right' style=';'>362.98</td>
        <td align='right' style=';'> 0.02</td>
        <td align='right' style=';'> 8.00</td>
        <th style=';'>&nbsp;</th>
        <td align='right' style=';'>287.78</td>
        <td align='right' style=';'>-0.428</td>
        <td align='right' style=';'> 5.65</td>
    </tr>
    <tr>
        <td align='right' style='border-bottom: 1px solid grey;'>&nbsp;&nbsp;Pellentesque Nec</td>
        <td align='right' style='border-bottom: 1px solid grey;'>360.80</td>
        <td align='right' style='border-bottom: 1px solid grey;'>-0.00</td>
        <td align='right' style='border-bottom: 1px solid grey;'> 7.51</td>
        <th style='border-bottom: 1px solid grey;'>&nbsp;</th>
        <td align='right' style='border-bottom: 1px solid grey;'>379.28</td>
        <td align='right' style='border-bottom: 1px solid grey;'>-0.57</td>
        <td align='right' style='border-bottom: 1px solid grey;'> 6.23</td>
    </tr>
    </tbody>
</table>
</div>

Fusce ac turpis quis ligula lacinia aliquet. Mauris ipsum. Nulla metus metus, ullamcorper vel, tincidunt sed, euismod in, nibh. Quisque volutpat condimentum velit. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Nam nec ante. Sed lacinia, urna non tincidunt mattis, tortor neque adipiscing diam, a cursus ipsum ante quis turpis. Nulla facilisi. Ut fringilla. Suspendisse potenti. Nunc feugiat mi a tellus consequat imperdiet. Vestibulum sapien. 

Etiam ultrices. Suspendisse in justo eu magna luctus suscipit. Sed lectus. Integer euismod lacus luctus magna. Quisque cursus, metus vitae pharetra auctor, sem massa mattis sem, at interdum magna augue eget diam. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Morbi lacinia molestie dui. Praesent blandit dolor. Sed non quam. In vel mi sit amet augue congue elementum. Morbi in ipsum sit amet pede facilisis laoreet. Donec lacus nunc, viverra nec, blandit vel, egestas et, augue. Vestibulum tincidunt malesuada tellus. Ut ultrices ultrices enim. 

### Second HTML Example Table

HTML Provides the most flexible table presentation I've found.  Here is another example

**Table 3. Another Table Produced Using HTML Directly** 
<div>
<table class='gmisc_table' style='border-collapse: collapse;'>
    <a name='Table 3.'></a>
    <thead>
    <tr>
        <th style='font-weight: 900; border-top: 4px double grey;'></th>
        <th align='center' colspan='3' style='font-weight: 900; border-bottom: 1px solid grey; border-top: 4px double grey;'>Mean Amet egestas</th><th style='border-top: 4px double grey;'>&nbsp;</th>
        <th align='center' colspan='3' style='font-weight: 900; border-bottom: 1px solid grey; border-top: 4px double grey;'>Median Amet egestas</th>
    </tr>
    <tr>
        <th style=';'>&nbsp;</th>
        <th align='center' style='border-bottom: 1px solid grey;'>Nec Nibh</th>
        <th align='center' style='border-bottom: 1px solid grey;'>Ultricies</th>
        <th align='center' style='border-bottom: 1px solid grey;'>Cras Purus</th>
        <th style='border-bottom: 1px solid grey;'>&nbsp;</th>
        <th align='center' style='border-bottom: 1px solid grey;'>Nec Nibh</th>
        <th align='center' style='border-bottom: 1px solid grey;'>Ultricies</th>
        <th align='center' style='border-bottom: 1px solid grey;'>Cras Purus</th>
    </tr>
    </thead><tbody>
    <tr><td align='left' style='border-bottom: 1px solid grey; font-weight: 900;'>Pellentesque</td></tr>
    <tr>
        <td align='right' style=';'>Without Dictumst </td>
        <td align='right' style=';'>5.57</td>
        <td align='right' style=';'> -0.20</td>
        <td align='right' style=';'> 2.36</td>
        <th style=';'>&nbsp;</th>
        <td align='right' style=';'>26.37</td>
        <td align='right' style=';'>-0.10</td>
        <td align='right' style=';'> 5.14</td>
    </tr>
    <tr>
        <td align='right' style=';'>With Dictumst </td>
        <td align='right' style=';'>4.74</td>
        <td align='right' style=';'>-0.08</td>
        <td align='right' style=';'> 2.18</td>
        <th style=';'>&nbsp;</th>
        <td align='right' style=';'>28.36</td>
        <td align='right' style=';'> 0.03</td>
        <td align='right' style=';'> 5.33</td>
    </tr>
    <tr><td align='left' style='border-bottom: 1px solid grey; font-weight: 900;'>Pellentesque Nec</td></tr>
    <tr>
        <td align='right' style=';'>Without Dictumst </td>
        <td align='right' style=';'>5.95</td>
        <td align='right' style=';'>-0.26</td>
        <td align='right' style=';'> 2.43</td>
        <th style=';'>&nbsp;</th>
        <td align='right' style=';'>27.10</td>
        <td align='right' style=';'>-0.27</td>
        <td align='right' style=';'> 5.20</td>
    </tr>
    <tr>
        <td align='right' style=';'>With Dictumst </td> 
        <td align='right' style=';'>4.52</td>
        <td align='right' style=';'> 0.09</td>
        <td align='right' style=';'> 2.13</td>
        <th style=';'>&nbsp;</th>
        <td align='right' style=';'>25.68</td>
        <td align='right' style=';'> 0.08</td>
        <td align='right' style=';'> 5.06</td>
    </tr>
    </tbody>
</table>
</div>

<!--  Markdown Version of Table 3
|----------------------+-------------+-------------+-------------+-------------+-------------+-------------|
|**Table 3.**          |             |             |             |             |             |             |
|                      |       | Mean Amet egestas |             |           |       | Median Amet egestas |
|:---------------------|------------:|------------:|:------------|------------:|------------:|------------:|
|                      |...............|.......................|...............|       |     |             |
|                      | Nec Nibh    |  Ultricies  |  Cras Purus | Nec Nibh    |  Ultricies  |  Cras Purus |
|                      |             |             |             |             |             |             |
| Pellentesque
| Without Dictumst     |    5.574    |    -0.196   |    2.360    |   26.366    |   -0.104    |    5.137    |
| With Dictumst        |    4.741    |    -0.075   |    2.177    |   28.364    |    0.034    |    5.329    |
|===
|                      |             |             |             |             |             |             |
| Pellentesque Nec
| Without Dictumst     |    5.948    |    -0.263    |   2.433    |   27.101    |   -0.266    |    5.199    |
| With Dictumst        |    4.519    |     0.094    |   2.125    |   25.679    |    0.084    |    5.060    |
|----------------------+-------------+-------------+-------------+-------------+---------------+-----------|
-->

# Figures and Charts
Here are some examples of how to include figures and charts.  These examples range from simple static images stored in a local directory or sourced from the web to interactive [D3 charts] produced using the [rCharts](http://ramnathv.github.io/rCharts/) package for the [R statistical programming language](http://www.r-project.org/).

## Static Figures

*Figure 1. From a File in the Local Directory*

<img src="img/Fig_1.png" alt="Fig.1" style="width: 600px;"/>

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer nec odio. Praesent libero. Sed cursus ante dapibus diam. Sed nisi. Nulla quis sem at nibh elementum imperdiet. Duis sagittis ipsum. Praesent mauris. Fusce nec tellus sed augue semper porta. Mauris massa. Vestibulum lacinia arcu eget nulla. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. 

## Images from the Web

<div class='content-node image'>
	<div class='image-content'>    
		<img src="http://octodex.github.com/images/baracktocat.jpg" style="width: 350px;"/>
	</div>
	<div class='caption'>Although this is the second figure of this document, it is labeled as 'Fig. 1' because it uses HTML code that is recognized as a specific 'class' in the document that allows for automatic figure counting (controlled in document_print.css).</div>
</div>

## Interactive D3 Charts
Static charts and plots can be saved as .png, .jpg or other raw files and included in a similar fashion to the two methods shown above.  Here I show how more interesting, interactive figures can be included.  Specifically, the following 3 charts have been produced using the [rCharts](http://ramnathv.github.io/rCharts/) package available for the open-source [R statistical programming language](http://www.r-project.org/).  This R package leverages the [D3 JavaScript library](http://d3js.org/) on the backend. D3 stands for 'Data-Driven Documents'.

### D3 Barchart example using a .js script file

<div class='content-node image'>
	<div class='image-content'>    
		<div id="chart" class="rChart nvd3Plot nvd3"></div>
			<script src="img/bar_chart_example.js" type="text/javascript" charset="utf-8"></script>
	</div>
	<div class='caption'> Example interactive bar chart created using the rChart package in R.  Click on the circles at the top of the chart to customize the display.</div>
</div>

### D3 Scatterplot example using inline HTML 'script'
The 2nd chart was created using these commands:

{% highlight r %}
p1 <- nPlot(mpg ~ wt, group = 'cyl', data = mtcars, type = 'scatterChart')
p1$xAxis(axisLabel = 'Weight')
p1
{% endhighlight %}

<div class='content-node image'>
	<div class='image-content'>    
		<div id='chart64af7f973c9b' class='rChart nvd3Plot nvd3'></div>

		<script type='text/javascript'>
			$(document).ready(function(){
			drawchart64af7f973c9b()
			});
			function drawchart64af7f973c9b(){ 
				var opts = {
					"dom": "chart64af7f973c9b", 
					"width": 700, 
					"height": 350, 
					"x": "wt", 
					"y": "mpg", 
					"group": "cyl", 
					"type": "scatterChart", 
					"id": "chart64af7f973c9b"}, 
				data = [
					{"mpg": 21.0, "cyl": 6, "disp": 160, "hp": 110, "drat": 3.9, "wt": 2.62, "qsec": 16.46, "vs": 0, "am": 1, "gear": 4, "carb": 4},
					{"mpg": 21.0, "cyl": 6, "disp": 160, "hp": 110, "drat": 3.9, "wt": 2.875, "qsec": 17.02, "vs": 0, "am": 1, "gear": 4, "carb": 4},
					{"mpg": 22.8, "cyl": 4, "disp": 108, "hp": 93, "drat": 3.85, "wt": 2.32, "qsec": 18.61, "vs": 1, "am": 1, "gear": 4, "carb": 1},
					{"mpg": 21.4, "cyl": 6, "disp": 258, "hp": 110, "drat": 3.08, "wt": 3.215, "qsec": 19.44, "vs": 1, "am": 0, "gear": 3, "carb": 1},
					{"mpg": 18.7, "cyl": 8, "disp": 360, "hp": 175, "drat": 3.15, "wt": 3.44, "qsec": 17.02, "vs": 0, "am": 0, "gear": 3, "carb": 2},
					{"mpg": 18.1, "cyl": 6, "disp": 225, "hp": 105, "drat": 2.76, "wt": 3.46, "qsec": 20.22, "vs": 1, "am": 0, "gear": 3, "carb": 1},
					{"mpg": 14.3, "cyl": 8, "disp": 360, "hp": 245, "drat": 3.21, "wt": 3.57, "qsec": 15.84, "vs": 0, "am": 0, "gear": 3, "carb": 4},
					{"mpg": 24.4, "cyl": 4, "disp": 146.7, "hp": 62, "drat": 3.69, "wt": 3.19, "qsec": 20, "vs": 1, "am": 0, "gear": 4, "carb": 2},
					{"mpg": 22.8, "cyl": 4, "disp": 140.8, "hp": 95, "drat": 3.92, "wt": 3.15, "qsec": 22.9, "vs": 1, "am": 0, "gear": 4, "carb": 2},
					{"mpg": 19.2, "cyl": 6, "disp": 167.6, "hp": 123, "drat": 3.92, "wt": 3.44, "qsec": 18.3, "vs": 1, "am": 0, "gear": 4, "carb": 4},
					{"mpg": 17.8, "cyl": 6, "disp": 167.6, "hp": 123, "drat": 3.92, "wt": 3.44, "qsec": 18.9, "vs": 1, "am": 0, "gear": 4, "carb": 4},
					{"mpg": 16.4, "cyl": 8, "disp": 275.8, "hp": 180, "drat": 3.07, "wt": 4.07, "qsec": 17.4, "vs": 0, "am": 0, "gear": 3, "carb": 3},
					{"mpg": 17.3, "cyl": 8, "disp": 275.8, "hp": 180, "drat": 3.07, "wt": 3.73, "qsec": 17.6, "vs": 0, "am": 0, "gear": 3, "carb": 3},
					{"mpg": 15.2, "cyl": 8, "disp": 275.8, "hp": 180, "drat": 3.07, "wt": 3.78, "qsec": 18, "vs": 0, "am": 0, "gear": 3, "carb": 3},
					{"mpg": 10.4, "cyl": 8, "disp": 472, "hp": 205, "drat": 2.93, "wt": 5.25, "qsec": 17.98, "vs": 0, "am": 0, "gear": 3, "carb": 4},
					{"mpg": 10.4, "cyl": 8, "disp": 460, "hp": 215, "drat": 3, "wt": 5.424, "qsec": 17.82, "vs": 0, "am": 0, "gear": 3, "carb": 4},
					{"mpg": 14.7, "cyl": 8, "disp": 440, "hp": 230, "drat": 3.23, "wt": 5.345, "qsec": 17.42, "vs": 0, "am": 0, "gear": 3, "carb": 4},
					{"mpg": 32.4, "cyl": 4, "disp": 78.7, "hp": 66, "drat": 4.08, "wt": 2.2, "qsec": 19.47, "vs": 1, "am": 1, "gear": 4, "carb": 1},
					{"mpg": 30.4, "cyl": 4, "disp": 75.7, "hp": 52, "drat": 4.93, "wt": 1.615, "qsec": 18.52, "vs": 1, "am": 1, "gear": 4, "carb": 2},
					{"mpg": 33.9, "cyl": 4, "disp": 71.1, "hp": 65, "drat": 4.22, "wt": 1.835, "qsec": 19.9, "vs": 1, "am": 1, "gear": 4, "carb": 1},
					{"mpg": 21.5, "cyl": 4, "disp": 120.1, "hp": 97, "drat": 3.7, "wt": 2.465, "qsec": 20.01, "vs": 1, "am": 0, "gear": 3, "carb": 1},
					{"mpg": 15.5, "cyl": 8, "disp": 318, "hp": 150, "drat": 2.76, "wt": 3.52, "qsec": 16.87, "vs": 0, "am": 0, "gear": 3, "carb": 2},
					{"mpg": 15.2, "cyl": 8, "disp": 304, "hp": 150, "drat": 3.15, "wt": 3.435, "qsec": 17.3, "vs": 0, "am": 0, "gear": 3, "carb": 2},
					{"mpg": 13.3, "cyl": 8, "disp": 350, "hp": 245, "drat": 3.73, "wt": 3.84, "qsec": 15.41, "vs": 0, "am": 0, "gear": 3, "carb": 4},
					{"mpg": 19.2, "cyl": 8, "disp": 400, "hp": 175, "drat": 3.08, "wt": 3.845, "qsec": 17.05, "vs": 0, "am": 0, "gear": 3, "carb": 2},
					{"mpg": 27.3, "cyl": 4, "disp": 79, "hp": 66, "drat": 4.08, "wt": 1.935, "qsec": 18.9, "vs": 1, "am": 1, "gear": 4, "carb": 1},
					{"mpg": 26.0, "cyl": 4, "disp": 120.3, "hp": 91, "drat": 4.43, "wt": 2.14, "qsec": 16.7, "vs": 0, "am": 1, "gear": 5, "carb": 2},
					{"mpg": 30.4, "cyl": 4, "disp": 95.1, "hp": 113, "drat": 3.77, "wt": 1.513, "qsec": 16.9, "vs": 1, "am": 1, "gear": 5, "carb": 2},
					{"mpg": 15.8, "cyl": 8, "disp": 351, "hp": 264, "drat": 4.22, "wt": 3.17, "qsec": 14.5, "vs": 0, "am": 1, "gear": 5, "carb": 4},
					{"mpg": 19.7, "cyl": 6, "disp": 145, "hp": 175, "drat": 3.62, "wt": 2.77, "qsec": 15.5, "vs": 0, "am": 1, "gear": 5, "carb": 6},
					{"mpg": 15.0, "cyl": 8, "disp": 301, "hp": 335, "drat": 3.54, "wt": 3.57, "qsec": 14.6, "vs": 0, "am": 1, "gear": 5, "carb": 8},
					{"mpg": 21.4, "cyl": 4, "disp": 121, "hp": 109, "drat": 4.11, "wt": 2.78, "qsec": 18.6, "vs": 1, "am": 1, "gear": 4, "carb": 2}]

				var data = d3.nest()
				.key(function(d){
				 return opts.group === undefined ? 'main' : d[opts.group]
				})
				.entries(data)

				nv.addGraph(function() {
					var chart = nv.models[opts.type]()
					 .x(function(d) { return d[opts.x] })
					 .y(function(d) { return d[opts.y] })
					 .width(opts.width)
					 .height(opts.height)

					chart.xAxis
					.axisLabel("Weight")

					d3.select("#" + opts.id)
					.append('svg')
					.datum(data)
					.transition().duration(500)
					.call(chart);

					nv.utils.windowResize(chart.update);
					return chart;
				});
			};
		</script>
		<div class='caption'> Example interactive scatter chart created using the rChart package in R.  Click on the circles at the top of the chart to customize the display.</div>
	</div>
</div>

D3 plots can also be saved as a stand alone HTML file and linked to from the main document, as [shown here](scatter_plot.html).  These .html files must be saved in the base directory (rather than the img/ directory for example) so that they have access to assets such as the .js and .css scripts.

### A third D3 rChart example, because I just can't get enough ...

This 3rd chart was created using these commands:

{% highlight r %}
dat <- data.frame(t = rep(0:23,each=4),
                  var = rep(LETTERS[1:4],4),
                  val = round(runif(4*24,0,50)))
				  
p8 <- nPlot(val ~ t, group = 'var', data = dat, 
    type = 'stackedAreaChart', id = 'chart')
p8
{% endhighlight %}

<div class='content-node image'>
	<div class='image-content'>    
		<div id="chart64af4f227d3" class="rChart nvd3Plot nvd3"></div>
			<script src="img/Stacked_Area_Chart_example.js" type="text/javascript" charset="utf-8"></script>
	</div>
	<div class='caption'> Example interactive Stacked Area Chart created using the rChart package in R.  Click on the circles at the top of the chart to customize the display.</div>
</div>


# References

<div id="citation" markdown="1">
Doe, J. (2010). *First Book*. Cambridge: Cambridge University Press.

Doe, J. (2012). Article. *Journal of Generic Studies*, *6*, 33–34.

Doe, J., Smith, S., & Roe, J. (2007). Why Water Is Wet:  A really long citation entry to provide an example of the hanging indent used in this document's citation div class. In S. Smith (Ed.), *Third Book*. Oxford: Oxford University Press.    
</div>

