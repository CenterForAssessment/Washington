---
layout: post
title: "To See a World in Grains of Sand"
author: [yihui]
categories: [Big data, Color, Base Graphics]
tags: [plotting symbols, scatterplot, graphical parameters, hexbin, alpha-transparency, overplotting, 2D kernel density estimation]
reviewer: []
---
{% include JB/setup %}

This article was borrowed from my [blog
post](http://yihui.name/en/2008/09/to-see-a-circle-in-a-pile-of-sand/) to show how to visualize a
large amount of data in scatter plots. Here is how the original data was generated:


{% highlight r %}
# generate the data
set.seed(20111105)
x = rbind(matrix(rnorm(10000 * 2), ncol = 2), local({
  r = runif(10000, 0, 2 * pi)
  0.5 * cbind(sin(r), cos(r))
}))
x = as.data.frame(x[sample(nrow(x)), ])
{% endhighlight %}


## Original scatter plot

It is not useful since you can see nothing.


{% highlight r %}
plot(x)
{% endhighlight %}

![plot of chunk plot-orig](http://isu.r-forge.r-project.org/vistat/2012-11-05-to-see-a-world-in-grains-of-sand/plot-orig.png) 


## Transparent colors

We take `alpha = 0.1` to generate semi-transparent colors.


{% highlight r %}
plot(x, col = rgb(0, 0, 0, 0.1))
{% endhighlight %}

![plot of chunk plot-alpha](http://isu.r-forge.r-project.org/vistat/2012-11-05-to-see-a-world-in-grains-of-sand/plot-alpha.png) 


## Set axes limits

Zoom into the point cloud:


{% highlight r %}
plot(x, xlim = c(-1, 1), ylim = c(-1, 1))
{% endhighlight %}

![plot of chunk plot-lim](http://isu.r-forge.r-project.org/vistat/2012-11-05-to-see-a-world-in-grains-of-sand/plot-lim.png) 


## Smaller symbols

Use smaller points:


{% highlight r %}
plot(x, pch = ".")
{% endhighlight %}

![plot of chunk plot-dot](http://isu.r-forge.r-project.org/vistat/2012-11-05-to-see-a-world-in-grains-of-sand/plot-dot.png) 


## Subset

Only take a look at a random subset:


{% highlight r %}
plot(x[sample(nrow(x), 1000), ])
{% endhighlight %}

![plot of chunk plot-subset](http://isu.r-forge.r-project.org/vistat/2012-11-05-to-see-a-world-in-grains-of-sand/plot-subset.png) 


## Hexagons

We can use the color of hexagons to denote the number of points in them:


{% highlight r %}
library(hexbin)
with(x, plot(hexbin(V1, V2)))
{% endhighlight %}

![plot of chunk plot-hexbin](http://isu.r-forge.r-project.org/vistat/2012-11-05-to-see-a-world-in-grains-of-sand/plot-hexbin.png) 


## 2D kernel density estimation

We can estimate the two-dimensional density surface using the `kde2d()` function in the **MASS**
package:


{% highlight r %}
library(MASS)
fit = kde2d(x[, 1], x[, 2])
# perspective plot by persp()
persp(fit$x, fit$y, fit$z)
{% endhighlight %}

![plot of chunk plot-kde2d](http://isu.r-forge.r-project.org/vistat/2012-11-05-to-see-a-world-in-grains-of-sand/plot-kde2d.png) 


That is only a static plot, and we can actually interact with the surface (e.g. rotating and
zooming) if we draw it with the **rgl** package:


{% highlight r %}
library(rgl)
# perspective plot by OpenGL
rgl.open()
rgl.surface(fit$x, fit$y, 5 * fit$z)
par3d(zoom = 0.7)
{% endhighlight %}

![plot of chunk plot-rgl](http://isu.r-forge.r-project.org/vistat/2012-11-05-to-see-a-world-in-grains-of-sand/plot-rgl.png) 


Run the code below to see the surface rotating automatically if you are interested:


{% highlight r %}
# animation
M = par3d("userMatrix")
play3d(par3dinterp(userMatrix = list(M, rotate3d(M, pi/2, 1, 0, 0), 
  rotate3d(M, pi/2, 0, 1, 0), rotate3d(M, pi, 0, 0, 1))), duration = 20)
{% endhighlight %}


<iframe src="http://player.vimeo.com/video/4745847" width="500" height="465" frameborder="0"
webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>

Please let me know if you have other ideas.
