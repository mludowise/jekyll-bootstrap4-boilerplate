---
layout: default
title:  "Stacked to horizontal"
date:   2017-07-08 23:39:00 +0800
readme: >
  Using a single set of `min` sizes, you can create a basic grid system that starts out stacked on extra small devices before becoming horizontal on desktop (medium) devices.
---
{% row %}
    {% col sm:8 %}col-sm-8{% endcol %}
    {% col sm:4 %}col-sm-4{% endcol %}
{% endrow %}
{% row %}
    {% col sm %}col-sm{% endcol %}
    {% col sm %}col-sm{% endcol %}
    {% col sm %}col-sm{% endcol %}
{% endrow %}
