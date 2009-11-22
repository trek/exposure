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
Default responses can be customized with the ActionController class method `response_for`. You can replace a response with a method name (as symbol), Proc object, or a block. You can respond differently to successful and unsuccessful execution by passing the `:on` option with a value of either `:success` or `:failure`.

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
  response_for :index, :is => Proc.new { render('scoped_index') }
end
{% endhighlight %}

{% highlight ruby %}
class PuppiesController < ApplicationController
  expose :puppies
  response_for :new, :on => :success do
    render('new_adoption_form')
  end
  
  response_for :new, :on => :failure do
    raise AdoptionNotAllowed
  end
end
{% endhighlight %}

Format-specific Responding
------------------
You can create responses for specific formats by passing `:format` option with an array of formats as symbols. The default option is `:html` only.

{% highlight ruby %}
class ProductsController < ApplicationController
  # remember to add pdf as an acceptable mime-type in your configuration
  # Mime::Type.register "application/pdf", :pdf
  expose :products
  response_for :show, :formats => :pdf do
    send_data(MyCoolPDFWriter.generate(@product),
            :filename => "#{@product.name}.pdf",
            :type => "application/pdf")
  end
end
{% endhighlight %}


[Previous: Building](/building.html) [Next: Flashing](/flashing.html)