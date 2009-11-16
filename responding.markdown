---
layout: default
title: Exposure responding
---

Responding
========

Action    | Success Response               | Failed Response
----------|--------------------------------|--------------------
`index`   | rendered `index`               | 404
`show`    | rendered `show`                | 404
`new`     | rendered `new`                 | 404
`create`  | redirect `show` of new object  | rendered `new`
`edit`    | rendered `edit`                | 404
`update`  | redirect `show` of object      | rendered `edit`
`destroy` | rendered `index`               | 

Customized Responding
------------------
Default responses can be customized with the ActionController method `response_for`. You can replace a response with a method name (as symbol), Proc object, or a block. You can respond differently to successful and unsuccessful execitions by passing the `:on` option with a value of either `:success` or `:failure`.

{% highlight ruby %}
class PostsController < ApplicationController
  expose :posts
  response_for :update, :on => :success, :is => :redirect_after_update
  private
    def redirect_after_update
      redirect_to post_url(@post)
    end
end
{% endhighlight %}

{% highlight ruby %}
class ProductsController < ApplicationController
  expose :products
  builder_for :index, :is => Proc.new { render('scoped_index') }
end
{% endhighlight %}

{% highlight ruby %}
class PuppiesController < ApplicationController
  expose :puppies
  builder_for :new, :on => :success do
    render('new_adoption_form')
  end
  
  builder_for :new, :on => :failure do
    raise AdoptionNotAllowed
  end
end
{% endhighlight %}

[Previous: Finding](/finding.html) [Next: Responding](/responding.html)