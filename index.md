---
layout: default
---

## Introduction

## Examples

{% for post in site.posts %}
### {{ post.title | escape }}

{{ post.readme | markdownify }}

<div class="card card-outline-primary">
    <div class="list-group list-group-flush">
        <div class="list-group-item example-content">
            {{ post.content | markdownify }}
        </div>
        <div class="list-group-item bg-faded">
{% highlight liquid %}
{{ post.content }}
{% endhighlight %}
        </div>
        <div class="list-group-item bg-faded">
            <pre>
                <code class="language-html" data-lang="html">
{% highlight html %}
{{ post.content | markdownify }}
{% endhighlight %}
                </code>
            </pre>
        </div>
    </div>
</div>
{% endfor %}
