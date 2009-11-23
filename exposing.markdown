---
layout: default

next_url:  finding
next_text: Finding
previous_url: rest-pattern
previous_text: The REST Pattern

title: Exposing
---

# Exposing

## Expose a resource

{% highlight ruby %}
class MembersController
  expose :members
end
{% endhighlight %}


## Nest a resource

{% highlight ruby %}
class PostsController
  expose :posts, :nested => [:member]
end
{% endhighlight %}

## Limit formats a resource

{% highlight ruby %}
class PostsController
  expose :posts, :only => [:html]
end
{% endhighlight %}