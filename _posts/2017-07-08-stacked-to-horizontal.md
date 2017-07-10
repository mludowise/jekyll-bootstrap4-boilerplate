---
layout: default
title:  "Stacked to horizontal"
date:   2017-07-08 23:39:00 +0800
readme: >
  Using a single set of `min` sizes, you can create a basic grid system that starts out stacked on extra small devices before becoming horizontal on desktop (medium) devices.
---
{% row %}
    {% col sm:8 %}1 of 2{% endcol %}
    {% col sm:8 %}2 of 2{% endcol %}
{% endrow %}
{% row %}
    {% col sm %}1 of 3{% endcol %}
    {% col sm %}2 of 3{% endcol %}
    {% col sm %}3 of 3{% endcol %}
{% endrow %}
