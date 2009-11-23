---
layout: default
title: Exposure building
---

Building
========

In the [previous chapter](/finding.html) we learned about `exposure`'s finding capabilities. Some actions (e.g. `new` and `create`) don't manage existing resources. Instead, they build new resources from parameterized data. The default building strategy is to call the resource's parent class with `new`, passing in parameters named for the resource's singular name. With the following code example

{% highlight ruby %}
class PostsController
  expose :posts
end
{% endhighlight %}

new `Post` objects in the `new` and `create` actions will be built with `Post.new(params[:post])` and stored in the variable names `@resource` and `@post`.

The following tables summarizes finding and variable assignment in resource controllers:  

Action    | Builder called               | Assigned variables
----------|------------------------------|--------------------
`index`   |                              | `@resources`, `@posts`
`show`    |                              | `@resource`, `@post`
`new`     | `Post.new(params[:post])`    | `@resource`, `@post`
`create`  | `Post.new(params[:post])`    | `@resource`, `@post`
`edit`    |                              | `@resource`, `@post`
`update`  |                              | `@resource`, `@post`
`destroy` |                              | `@resource`, `@post`

Customized Building
------------------
Default building can be customized with the ActionController method `builder_for`. You can replace a builder with a method name (as symbol), Proc object, or a block.  The result of execution will be stored in the resource's variable name

{% highlight ruby %}
class PostsController < ApplicationController
  expose :posts
  builder_for :post, :is => :new_post
  private
    def new_post
      Post.new(params[:post_data])
    end
end
{% endhighlight %}

{% highlight ruby %}
class ProductsController < ApplicationController
  expose :products
  builder_for :product, :is => Proc.new { Product.clone!(params[:old_product_id])  }
end
{% endhighlight %}

{% highlight ruby %}
class PuppiesController < ApplicationController
  expose :puppies
  builder_for :puppy do
    Puppy.new(params[:puppy].merge({:adopted => true}))
  end
end
{% endhighlight %}

[Previous: Finding](/finding.html) [Next: Responding](/responding.html)