---
layout: post
title: "Mathematical Annotation in R"
author: [rcore, yulijia, kbroman, kushey]
categories: [Base Graphics]
tags: [mathematical annotation, Greek letters]
reviewer: [yihui]
---
{% include JB/setup %}

Want to write mathematical symbols and expressions in R graphics? You can use an R `expression()`
instead of normal text, e.g. `plot(1:10, main = expression(alpha + beta))`. Below is a demo that
shows you everything about plotting math in R (it was written by the R Core Team; see `?plotmath`
for details):


{% highlight r %}
demo(plotmath)
{% endhighlight %}



![plot of chunk plotmath](http://isu.r-forge.r-project.org/vistat/2013-04-08-mathematical-annotation-in-r/plotmath1.png) ![plot of chunk plotmath](http://isu.r-forge.r-project.org/vistat/2013-04-08-mathematical-annotation-in-r/plotmath2.png) ![plot of chunk plotmath](http://isu.r-forge.r-project.org/vistat/2013-04-08-mathematical-annotation-in-r/plotmath3.png) ![plot of chunk plotmath](http://isu.r-forge.r-project.org/vistat/2013-04-08-mathematical-annotation-in-r/plotmath4.png) ![plot of chunk plotmath](http://isu.r-forge.r-project.org/vistat/2013-04-08-mathematical-annotation-in-r/plotmath5.png) 


## Combining expressions and text

If you want to combine multiple mathematical expressions with text, use `paste()` _inside_
`expression()`, as in the following.


{% highlight r %}
par(mar = c(4, 4, 2, 0.1))
plot(rnorm(100), rnorm(100),
  xlab = expression(hat(mu)[0]), ylab = expression(alpha^beta),
  main = expression(paste("Plot of ", alpha^beta, " versus ", hat(mu)[0])))
{% endhighlight %}

![plot of chunk math-text](http://isu.r-forge.r-project.org/vistat/2013-04-08-mathematical-annotation-in-r/math-text.png) 


Finally, if we want to include variables from an R session in mathematical expressions, and
substitute in their actual values, we can use `substitute()`.


{% highlight r %}
par(mar = c(4, 4, 2, 0.1))
x_mean <- 1.5
x_sd <- 1.2
hist(rnorm(100, x_mean, x_sd),
  main = substitute(
    paste(X[i], " ~ N(", mu, "=", m, ", ", sigma^2, "=", s2, ")"),
    list(m = x_mean, s2 = x_sd^2)
  )
)
{% endhighlight %}

![plot of chunk math-text-sub](http://isu.r-forge.r-project.org/vistat/2013-04-08-mathematical-annotation-in-r/math-text-sub.png) 

