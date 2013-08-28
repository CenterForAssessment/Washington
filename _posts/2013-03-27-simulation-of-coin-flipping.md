---
layout: post
title: "Simulation of Coin Flipping"
author: [yulijia]
categories: [Animation, Probability]
tags: [coin flipping, Bernoulli trial]
reviewer: [yihui]
animation: true
---
{% include JB/setup %}

The function `flip.coin()` in the [**animation** package](http://yihui.name/animation) provides a
simulation to the process of flipping coins and computes the frequencies for `heads` and `tails`.
Coin flipping is a well-known [Bernoulli trial](http://en.wikipedia.org/wiki/Bernoulli_trial). When
you flip a coin, there are two possible outcomes: `head` or `tail`. A fair coin has the probability
0.5 for `head` by definition.

## Head or tail

We toss a fair coin 100 times below.


{% highlight r %}
library(animation)
ani.options(nmax = 100, interval = 0.3)
par(mar = c(2, 4, 2, 2))
flip.coin(bg = "yellow")
{% endhighlight %}


<div class="scianimator">
<div id="head_or_tail" style="display: inline-block;">
</div>
</div>
<script type="text/javascript">
  (function($) {
    $(document).ready(function() {
      var imgs = Array(100);
      for (i=0; ; i++) {
        if (i == imgs.length) break;
        imgs[i] = "http://isu.r-forge.r-project.org/vistat/2013-03-27-simulation-of-coin-flipping/head-or-tail" + (i + 1) + ".png";
      }
      $("#head_or_tail").scianimator({
          "images": imgs,
          "delay": 300,
          "controls": ["first", "previous", "play", "next", "last", "loop", "speed"],
      });
      $("#head_or_tail").scianimator("play");
    });
  })(jQuery);
</script>


Note the outcome is random, so if you run the code above again, you are likely to see different
results, but on average you should get 50 heads and 50 tails in the long run.

## Generalization

The coin here does not have to mean a coin literally. We can generalize it to an object that can
produce $n$ possible outcomes. For example, three outcomes `Head`, `Stand` (a coin may stand on the
table) and `Tail` with probabilities 0.45, 0.1 and 0.45 respectively:


{% highlight r %}
ani.options(nmax = 100, interval = 0.3)
par(mar = c(2, 4, 2, 2))
flip.coin(faces = c("Head", "Stand", "Tail"), type = "n", prob = c(0.45, 
  0.1, 0.45), col = c(1, 2, 4))
{% endhighlight %}


<div class="scianimator">
<div id="coin_stands" style="display: inline-block;">
</div>
</div>
<script type="text/javascript">
  (function($) {
    $(document).ready(function() {
      var imgs = Array(100);
      for (i=0; ; i++) {
        if (i == imgs.length) break;
        imgs[i] = "http://isu.r-forge.r-project.org/vistat/2013-03-27-simulation-of-coin-flipping/coin-stands" + (i + 1) + ".png";
      }
      $("#coin_stands").scianimator({
          "images": imgs,
          "delay": 300,
          "controls": ["first", "previous", "play", "next", "last", "loop", "speed"],
      });
      $("#coin_stands").scianimator("play");
    });
  })(jQuery);
</script>

