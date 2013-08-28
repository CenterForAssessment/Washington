---
layout: post
title: "Brownian Motion with R"
author: [taiyun]
categories: [Animation, Simulation]
tags: [Brownian motion, Normal distribution]
reviewer: [yihui]
animation: true
---
{% include JB/setup %}

We can use the [**animation** package](http://yihui.name/animation) to produce animations in R.
This short article shows you how to create a Brownian motion with the `brownian.motion()` function.

Simply speaking, a Brownian motion shows the trace of the coordinates

$$x_{i+1}=x_{i}+\epsilon_{i+1}$$

where $\epsilon_i$ is i.i.d from a standard Normal distribution. That is fairly easy to program in
R -- it is nothing but `cumsum(rnorm(n))`, and that is what `brownian.motion()` does internally.


{% highlight r %}
library(animation)
ani.options(nmax = 50)  # create 50 image frames
set.seed(20121106)
brownian.motion(n = 20, pch = 21, cex = 4, col = "red", bg = "yellow", 
  xlim = c(-10, 10), ylim = c(-15, 15))
{% endhighlight %}


<div class="scianimator">
<div id="bw_fun" style="display: inline-block;">
</div>
</div>
<script type="text/javascript">
  (function($) {
    $(document).ready(function() {
      var imgs = Array(50);
      for (i=0; ; i++) {
        if (i == imgs.length) break;
        imgs[i] = "http://isu.r-forge.r-project.org/vistat/2012-11-06-brownian-motion-with-r/bw-fun" + (i + 1) + ".png";
      }
      $("#bw_fun").scianimator({
          "images": imgs,
          "delay": 200,
          "controls": ["first", "previous", "play", "next", "last", "loop", "speed"],
      });
      $("#bw_fun").scianimator("play");
    });
  })(jQuery);
</script>


Done.
