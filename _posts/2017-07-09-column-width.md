---
layout: example
title:  "Setting one column width"
date:   2017-07-08 23:39:00 +0800
readme: >
  Auto-layout for flexbox grid columns also means you can set the width of one column and the others will automatically resize around it. You may use predefined grid classes (as shown below), grid mixins, or inline widths. Note that the other columns will resize no matter the width of the center column.
---
{% row %}
    {% col %}1 of 3{% endcol %}
    {% col width=6 %}2 of 3 (wider){% endcol %}
    {% col %}3 of 3{% endcol %}
{% endrow %}
{% row %}
    {% col %}1 of 3{% endcol %}
    {% col width=5 %}2 of 3 (wider){% endcol %}
    {% col %}3 of 3{% endcol %}
{% endrow %}
