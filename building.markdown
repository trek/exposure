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

<table>
<thead>
<tr>
<th align="center">Action    </th>
<th align="center"> Builder called               </th>
<th align="center"> Assigned variables</th>
</tr>
</thead>
<tbody>
<tr>
<td align="center"><code>index</code>   </td>
<td align="center">                              </td>
<td align="center"> <code>@resources</code>, <code>@posts</code></td>
</tr>
<tr>
<td align="center"><code>show</code>    </td>
<td align="center">                              </td>
<td align="center"> <code>@resource</code>, <code>@post</code></td>
</tr>
<tr>
<td align="center"><code>new</code>     </td>
<td align="center"> <code>Post.new(params[:post])</code>    </td>
<td align="center"> <code>@resource</code>, <code>@post</code></td>
</tr>
<tr>
<td align="center"><code>create</code>  </td>
<td align="center"> <code>Post.new(params[:post])</code>    </td>
<td align="center"> <code>@resource</code>, <code>@post</code></td>
</tr>
<tr>
<td align="center"><code>edit</code>    </td>
<td align="center">                              </td>
<td align="center"> <code>@resource</code>, <code>@post</code></td>
</tr>
<tr>
<td align="center"><code>update</code>  </td>
<td align="center">                              </td>
<td align="center"> <code>@resource</code>, <code>@post</code></td>
</tr>
<tr>
<td align="center"><code>destroy</code> </td>
<td align="center">                              </td>
<td align="center"> <code>@resource</code>, <code>@post</code></td>
</tr>
</tbody>
</table>


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