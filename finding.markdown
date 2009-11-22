---
layout: default
title: Exposure finding
---

Finding
========

The default behavior for finding resources in exposure is finding with the named scope of `all` for multiple resources and finding by `id` obtained from `params` for singular resources.  The following code example:

{% highlight ruby %}
class MembersController
  expose :members
end
{% endhighlight %}

will find all members with `Member.all` and individual members with `Member.find(params[:id])`.  Finding a collection of resources occurs in the `index` action. Finding individual resources occurs in `show`, `edit`, `update`, and `destroy` actions.  Found resources are referenced by two variable names, based on their resource type.  With a resource type of `Member`, collections will be referenced by `@resources` and `@members`.  Individual resources will be referenced by `@resource` and `@member`.

The following tables summarizes finding and variable assignment in resource controllers:  

Action | Finder called                | Assigned variables
-------|------------------------------|--------------------
`index`| `Business.all`               | `@resources`, `@businesses`
`show` | `Business.find(params[:id])` | `@resource`, `@business`
`new`  |                              | `@resource`, `@business`
`create` |                            | `@resource`, `@business`
`edit` | `Business.find(params[:id])` | `@resource`, `@business`
`update` | `Business.find(params[:id])` | `@resource`, `@business`
`destroy`| `Business.find(params[:id])` | `@resource`, `@business`

Customized Finding
------------------
Default finding can be customized with the ActionController method `finder_for`. You can replace a finder with a method name (as symbol), Proc object, or a block.  The result of execution will be stored in the resource's variable name

{% highlight ruby %}
class PostsController < ApplicationController
  expose :posts
  finder_for :post, :is => :current_post
  private
    def current_post
      Post.find_by_permalink(params[:permalink])
    end
end
{% endhighlight %}

{% highlight ruby %}
class ProductsController < ApplicationController
  expose :products
  finder_for :products, :is => Proc.new { Product.top_sellers  }
end
{% endhighlight %}

{% highlight ruby %}
class PuppiesController < ApplicationController
  expose :puppies
  finder_for :puppy do
    Puppy.find_by_name_and_breed(params[:name], params[:breed_id])
  end
end
{% endhighlight %}

[Previous: Exposing Resources](/exposing.html) [Next: Building](/building.html)
  