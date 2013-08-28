---
layout: post
title: "Demonstration of the Central Limit Theorem"
author: [yulijia]
categories: [Animation, Probability]
tags: [Central Limit Theorem, Poisson distribution, Cauchy distribution]
reviewer: [yihui]
animation: true
---
{% include JB/setup %}

In [Probability Theory](http://en.wikipedia.org/wiki/Probability_theory), the [Central Limit
Theorem (CLT)](http://en.wikipedia.org/wiki/Central_limit_theorem) states that, given certain
conditions, the mean of a sufficiently large number of independent random variables, each with a
well-defined mean and well-defined variance, will be approximately normally distributed.

As shown in the [Bean Machine](/2013/04/bean-machine/) article, CLT has a number of variants. This
article shows you as long as the conditions of CLT are satisfied, the distribution of the sample
mean will be approximate to the Normal distribution when the sample size n is large enough, no
matter what is the original distribution.

In the [**animation** package](http://yihui.name/animation), there is a function named `clt.ani()`.
It shows the distribution of the sample mean when the sample size $$n$$ grows up. The test
`shapiro.test()` is provided as a measure of normality.

## Classical Central Limit Theorem

With the parameter `FUN` in the function `clt.ani()` you can select distribution which will be
shown in the animation. Here is the example with the [Poisson
distribution](http://en.wikipedia.org/wiki/Poisson_distribution).


{% highlight r %}
library(animation)
ani.options(interval = 0.5)
par(mar = c(3, 3, 1, 0.5), mgp = c(1.5, 0.5, 0), tcl = -0.3)
lambda = 4
f = function(n) rpois(n, lambda)
clt.ani(FUN = f, mean = lambda, sd = lambda)
{% endhighlight %}


<div class="scianimator">
<div id="poisson_clt" style="display: inline-block;">
</div>
</div>
<script type="text/javascript">
  (function($) {
    $(document).ready(function() {
      var imgs = Array(50);
      for (i=0; ; i++) {
        if (i == imgs.length) break;
        imgs[i] = "http://isu.r-forge.r-project.org/vistat/2013-04-15-central-limit-theorem/poisson-clt" + (i + 1) + ".png";
      }
      $("#poisson_clt").scianimator({
          "images": imgs,
          "delay": 500,
          "controls": ["first", "previous", "play", "next", "last", "loop", "speed"],
      });
      $("#poisson_clt").scianimator("play");
    });
  })(jQuery);
</script>


## When CLT does not work

The [Cauchy distribution](http://en.wikipedia.org/wiki/Cauchy_distribution) is an example of a
distribution which has no mean, variance or higher moments defined, so we cannot apply CLT to this
distribution.


{% highlight r %}
ani.options(interval = 0.5)
par(mar = c(3, 3, 1, 0.5), mgp = c(1.5, 0.5, 0), tcl = -0.3)
f = function(n) rcauchy(n, location = 0, scale = 2)
clt.ani(FUN = f, mean = NA, sd = NA)
{% endhighlight %}


<div class="scianimator">
<div id="cauchy_clt" style="display: inline-block;">
</div>
</div>
<script type="text/javascript">
  (function($) {
    $(document).ready(function() {
      var imgs = Array(50);
      for (i=0; ; i++) {
        if (i == imgs.length) break;
        imgs[i] = "http://isu.r-forge.r-project.org/vistat/2013-04-15-central-limit-theorem/cauchy-clt" + (i + 1) + ".png";
      }
      $("#cauchy_clt").scianimator({
          "images": imgs,
          "delay": 500,
          "controls": ["first", "previous", "play", "next", "last", "loop", "speed"],
      });
      $("#cauchy_clt").scianimator("play");
    });
  })(jQuery);
</script>

