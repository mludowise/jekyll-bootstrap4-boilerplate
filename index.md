---
layout: default
---

## Introduction

## Examples

{% for post in site.posts reversed %}
### {{ post.title | escape }}

{{ post.readme | markdownify }}
<div class="example">
    <div class="example-content">
        {{ post.content }}
    </div>
    <div class="example-code">
{% highlight liquid %}
{{ post.raw }}
{% endhighlight %}
    </div>
    <div class="example-code">
{% highlight html %}
{{ post.content }}
{% endhighlight %}
    </div>
</div>
{% endfor %}
