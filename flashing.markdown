---
layout: default
title: Exposure flashing
---

Flashing
========
Exposure includes a number of default flash message for successful object mutations (`create`, `update`, and `destroy`).  These are set to `flash[:notice]`. The following tables summarizes flash message defaults with an example resource type of `:pirates`:

Action    | Success flash message          | Failed flash message
----------|--------------------------------|--------------------
`index`   |                                | 
`show`    |                                | 
`new`     |                                | 
`create`  | Pirate successfully created    | 
`edit`    |                                | 
`update`  | Pirate successfully updated    | 
`destroy` | Pirate successfully removed    | 

Customized Flash Messages
------------------
Default flash messages can be customized with the ActionController class method `flash_for`. You can replace a flash message with a method name (as symbol), `String`, `Proc` object, or a block. You can flash different messages for successful and unsuccessful execution by passing the `:on` option with a value of either `:success` or `:failure`.

{% highlight ruby %}
class PostsController < ApplicationController
  expose :posts
  flash_for :create, :on => :success, :is => :post_created
  private
    def post_created
      "Congrats! We've added the #{@post.title} to your page!"
    end
end
{% endhighlight %}

{% highlight ruby %}
class ProductsController < ApplicationController
  expose :products
  flash_for :update, :on => :failure, :is => "ERROR: Couldn't save"
end
{% endhighlight %}

{% highlight ruby %}
class PuppiesController < ApplicationController
  expose :puppies
  flash_for :create, :on => :success do
    "Added #{@puppy.name} for adoption."
  end
  
  flash_for :create, :on => :failure do
    "Ooops, #{@puppy.name} could not be added for adoption."
  end
end
{% endhighlight %}

[Previous: Responding](/responding.html) [Next: Callbacks](/callbacks.html)
