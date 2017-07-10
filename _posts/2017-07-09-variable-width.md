---
layout: example
title:  "Variable width content"
date:   2017-07-08 23:39:00 +0800
readme: >
  Using the `auto` width, columns can size itself based on the natural width of its content. This is super handy with single line content like inputs, numbers, etc. This, in conjunction with horizontal alignment classes, is very useful for centering layouts with uneven column sizes as viewport width changes.
---
{% row class:justify-content-md-center %}
    {% col width:* lg:2 %}1 of 3{% endcol %}
    {% col width:12 md:auto %}Variable width content{% endcol %}
    {% col width:* lg:2 %}3 of 3{% endcol %}
{% endrow %}
{% row %}
    {% col %}1 of 3{% endcol %}
    {% col width:12 md:auto %}Variable width content{% endcol %}
    {% col width:* lg:2 %}3 of 3{% endcol %}
{% endrow %}
