---
layout: post
title: "Making Visual Illusions in R"
author: [yulijia]
categories: [Animation, Fun]
tags: [Scintillating grid, Hermann grid, Lilac chaser]
reviewer: [yihui]
animation: true
---
{% include JB/setup %}

This article demonstrates how to make [visual
illusions](http://en.wikipedia.org/wiki/Optical_illusion) with R. A visual illusion is a distortion
of form, size or color in the visual field. In the [**animation**
package](http://yihui.name/animation), functions `vi.grid.illusion()` and `vi.lilac.chaser()` can
be used to produce visual illusions.

## Scintillating grid illusion

`vi.grid.illusion()` function provides illustrations for the Scintillating grid illusion and
Hermann grid illusion. They are two most common types of [grid
illusions](http://en.wikipedia.org/wiki/Grid_illusion).

You can see dark dots appear and disappear rapidly at random intersections.


{% highlight r %}
library(animation)
vi.grid.illusion()
{% endhighlight %}

![plot of chunk scintillating-grid-illusion](http://isu.r-forge.r-project.org/vistat/2013-03-26-make-visual-illusions-in-r/scintillating-grid-illusion.png) 


## Hermann grid illusion

From Hermann grid illusion picture, you can see grey blobs disappear when looking directly at an
intersection.


{% highlight r %}
vi.grid.illusion(type = "h", lwd = 22, nrow = 5, ncol = 5, col = "white")
{% endhighlight %}

![plot of chunk hermann-grid-illusion](http://isu.r-forge.r-project.org/vistat/2013-03-26-make-visual-illusions-in-r/hermann-grid-illusion.png) 


## Lilac Chaser

We can draw a [Lilac chaser](http://en.wikipedia.org/wiki/Lilac_chaser) with the function
`vi.lilac.chaser()`.

Stare at the center cross for a few (say 30) seconds to experience the illusion.

- A gap running around the circle of lilac discs;
- A green disc running around the circle of lilac discs in place of the gap;
- The green disc running around on the grey background, with the lilac discs having disappeared in sequence.


{% highlight r %}
ani.options(nmax = 20)
par(mar = c(1, 1, 1, 1))
vi.lilac.chaser()
{% endhighlight %}


<div class="scianimator">
<div id="lilac_chaser" style="display: inline-block;">
</div>
</div>
<script type="text/javascript">
  (function($) {
    $(document).ready(function() {
      var imgs = Array(15);
      for (i=0; ; i++) {
        if (i == imgs.length) break;
        imgs[i] = "http://isu.r-forge.r-project.org/vistat/2013-03-26-make-visual-illusions-in-r/lilac-chaser" + (i + 1) + ".png";
      }
      $("#lilac_chaser").scianimator({
          "images": imgs,
          "delay": 50,
          "controls": ["first", "previous", "play", "next", "last", "loop", "speed"],
      });
      $("#lilac_chaser").scianimator("play");
    });
  })(jQuery);
</script>


## Note

Don’t worry if you can't see all the phenomena described. For many illusions, there is a percentage
of people with perfectly normal vision who just don’t see it, often for reasons currently unknown.

## Further reading

You can see more illusions created by [Kohske](http://rpubs.com/kohske/R-de-illusion) in R, which
also illustrated the power of the **grid** package.
