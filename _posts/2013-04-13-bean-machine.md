---
layout: post
title: "The Bean Machine and the Central Limit Theorem"
author: [yulijia]
categories: [Animation, Probability]
tags: [Bean machine, Central Limit Theorem]
reviewer: [yihui]
animation: true
---
{% include JB/setup %}

The bean machine, also known as the quincunx or Galton box, is a device invented by Sir [Francis
Galton](http://en.wikipedia.org/wiki/Francis_Galton) to demonstrate the [Central Limit
Theorem](http://en.wikipedia.org/wiki/Central_limit_theorem), in particular that the Normal
distribution is approximated from the Binomial distribution, or properly speaking, [de
Moivre–Laplace theorem](http://en.wikipedia.org/wiki/De_Moivre%E2%80%93Laplace_theorem).

The function `quincunx()` in the [**animation** package](http://yihui.name/animation) shows you how
balls bounce left and right as they hit the pins. You can see the height of ball columns in the
bins approximates a [bell curve](http://en.wikipedia.org/wiki/Normal_distribution).



{% highlight r %}
library(animation)
ani.options(interval = 0.03, nmax = 213)
quincunx()
{% endhighlight %}


<div class="scianimator">
<div id="bean_machine" style="display: inline-block;">
</div>
</div>
<script type="text/javascript">
  (function($) {
    $(document).ready(function() {
      var imgs = Array(212);
      for (i=0; ; i++) {
        if (i == imgs.length) break;
        imgs[i] = "http://isu.r-forge.r-project.org/vistat/2013-04-13-bean-machine/bean-machine" + (i + 1) + ".png";
      }
      $("#bean_machine").scianimator({
          "images": imgs,
          "delay": 50,
          "controls": ["first", "previous", "play", "next", "last", "loop", "speed"],
      });
      $("#bean_machine").scianimator("play");
    });
  })(jQuery);
</script>

