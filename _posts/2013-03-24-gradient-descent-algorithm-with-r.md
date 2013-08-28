---
layout: post
title: "Demonstration of the Gradient Descent Algorithm"
author: [yulijia]
categories: [Animation, Computational Statistics]
tags: [gradient descent algorithm]
reviewer: [yihui]
animation: true
---
{% include JB/setup %}

In the [**animation** package](http://yihui.name/animation), there is a function named
`grad.desc()`. It provides a visual illustration for the process of minimizing a real-valued
function through the [Gradient Descent Algorithm](http://en.wikipedia.org/wiki/Gradient_descent).
The two examples below show you how to use the `grad.desc()` function.

## A simple function

The default objective function in `grad.desc()` is $$f(x,y)=x{^2}+2y{^2}$$. The arrows will take
you to the minima step by step:


{% highlight r %}
library(animation)
par(mar = c(4, 4, 2, 0.1))
grad.desc()
{% endhighlight %}


<div class="scianimator">
<div id="grad_desc_right" style="display: inline-block;">
</div>
</div>
<script type="text/javascript">
  (function($) {
    $(document).ready(function() {
      var imgs = Array(36);
      for (i=0; ; i++) {
        if (i == imgs.length) break;
        imgs[i] = "http://isu.r-forge.r-project.org/vistat/2013-03-24-gradient-descent-algorithm-with-r/grad-desc-right" + (i + 1) + ".png";
      }
      $("#grad_desc_right").scianimator({
          "images": imgs,
          "delay": 200,
          "controls": ["first", "previous", "play", "next", "last", "loop", "speed"],
      });
      $("#grad_desc_right").scianimator("play");
    });
  })(jQuery);
</script>


## When the algorithm fails

This example shows how the gradient descent algorithm will fail with a too large step length.

To find a local minimum of a bivariate objective function:

$$z=\sin(\frac{1}{2}x{^2}-\frac{1}{4}y{^4}+3)\cos(2x+1-e{^y})$$


{% highlight r %}
ani.options(nmax = 70)
par(mar = c(4, 4, 2, 0.1))
f2 = function(x, y) sin(1/2 * x^2 - 1/4 * y^2 + 3) * cos(2 * x + 1 - 
  exp(y))
grad.desc(f2, c(-2, -2, 2, 2), c(-1, 0.5), gamma = 0.3, tol = 1e-04)
{% endhighlight %}



{% highlight text %}
## Warning: Maximum number of iterations reached!
{% endhighlight %}


<div class="scianimator">
<div id="grad_desc_wrong" style="display: inline-block;">
</div>
</div>
<script type="text/javascript">
  (function($) {
    $(document).ready(function() {
      var imgs = Array(70);
      for (i=0; ; i++) {
        if (i == imgs.length) break;
        imgs[i] = "http://isu.r-forge.r-project.org/vistat/2013-03-24-gradient-descent-algorithm-with-r/grad-desc-wrong" + (i + 1) + ".png";
      }
      $("#grad_desc_wrong").scianimator({
          "images": imgs,
          "delay": 200,
          "controls": ["first", "previous", "play", "next", "last", "loop", "speed"],
      });
      $("#grad_desc_wrong").scianimator("play");
    });
  })(jQuery);
</script>


Apparently the arrows get lost eventually. You can replace `gamma=0.3` with a smaller value and
retry the function.
