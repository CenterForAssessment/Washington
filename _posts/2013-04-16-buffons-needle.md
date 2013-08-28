---
layout: post
title: "Buffon's needle"
author: [yulijia]
categories: [Animation, Probability]
tags: [Buffon's needle, Monte Carlo, Pi]
reviewer: [yihui]
animation: true
---
{% include JB/setup %}

Given a needle of length $$L$$ dropped on a plane ruled with parallel lines $$D$$ units apart, what
is the probability that the needle will cross a line? This question is first posed in the 18th
century by [Georges-Louis Leclerc, Comte de
Buffon](http://en.wikipedia.org/wiki/Georges-Louis_Leclerc,_Comte_de_Buffon). The answer is
$$P=\frac{2L}{D\pi}$$ where $$D$$ is the distance between two adjacent lines, and $$L$$ is the
length of the needle.

The solution, in the case where the needle length is not greater than the width of the strips, can
be used to design a [Monte Carlo method](http://en.wikipedia.org/wiki/Monte_Carlo_method) for
approximating the number $$\pi$$.

In the [**animation** package](http://yihui.name/animation), the function `buffon.needle()` can be
used to simulate Buffon's needle. There are three graphs made in each step: the top one is a
simulation of the scenario, the bottom-left one can help us understand the connection between
dropping needles and the mathematical method to estimate $$\pi$$, and the bottom-right one is the
simulation result $$\pi$$ for each drop.


{% highlight r %}
library(animation)
ani.options(nmax = 100, interval = 0.5)
par(mar = c(3, 2.5, 0.5, 0.2), pch = 20, mgp = c(1.5, 0.5, 0))
buffon.needle(mat = matrix(c(1, 2, 1, 3), 2))
{% endhighlight %}


<div class="scianimator">
<div id="buffon_needle" style="display: inline-block;">
</div>
</div>
<script type="text/javascript">
  (function($) {
    $(document).ready(function() {
      var imgs = Array(100);
      for (i=0; ; i++) {
        if (i == imgs.length) break;
        imgs[i] = "http://isu.r-forge.r-project.org/vistat/2013-04-16-buffons-needle/buffon-needle" + (i + 1) + ".png";
      }
      $("#buffon_needle").scianimator({
          "images": imgs,
          "delay": 500,
          "controls": ["first", "previous", "play", "next", "last", "loop", "speed"],
      });
      $("#buffon_needle").scianimator("play");
    });
  })(jQuery);
</script>


You can use larger `nmax` values in the code to drop the needle for more times.
