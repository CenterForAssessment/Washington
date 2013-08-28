---
layout: post
title: "Demonstration of the Law of Large Numbers"
author: [yulijia]
categories: [Animation, Probability]
tags: [Law of Large Numbers, Chi-squared distribution]
reviewer: [yihui]
animation: true
---
{% include JB/setup %}

The [Law of Large Numbers](http://en.wikipedia.org/wiki/Law_of_large_numbers) (LLN) basically
states that the average obtained from a large number of trials should be close to the expected
value, and will tend to become closer as more trials are performed.

The function `lln.ani()` in the [**animation** package](http://yihui.name/animation) provides us a
visualization method for the LLN. It plots the sample mean as the sample size grows to check
whether the sample mean approaches to the population mean. Here we make an animation with the
[Chi-squared distribution](http://en.wikipedia.org/wiki/Chi-squared_distribution) as the population
distribution.


{% highlight r %}
library(animation)
ani.options(interval = 0.3)
lln.ani(FUN = function(n, mu) rchisq(n, df = mu), mu = 5, cex = 0.6)
{% endhighlight %}


<div class="scianimator">
<div id="chi_squared" style="display: inline-block;">
</div>
</div>
<script type="text/javascript">
  (function($) {
    $(document).ready(function() {
      var imgs = Array(50);
      for (i=0; ; i++) {
        if (i == imgs.length) break;
        imgs[i] = "http://isu.r-forge.r-project.org/vistat/2013-04-18-law-of-large-numbers/chi-squared" + (i + 1) + ".png";
      }
      $("#chi_squared").scianimator({
          "images": imgs,
          "delay": 300,
          "controls": ["first", "previous", "play", "next", "last", "loop", "speed"],
      });
      $("#chi_squared").scianimator("play");
    });
  })(jQuery);
</script>

