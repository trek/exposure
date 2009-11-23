---
layout: default

next_url:  flashing
next_text: Flashing
previous_url: building
previous_text: Building

title: Exposure responding
---

Responding
========

<table>
<thead>
<tr>
<th>Action    </th>
<th> Success Response               </th>
<th> Failed Response</th>
</tr>
</thead>
<tbody>
<tr>
<td><code>index</code>   </td>
<td> rendered <code>index</code>               </td>
<td> 404</td>
</tr>
<tr>
<td><code>show</code>    </td>
<td> rendered <code>show</code>                </td>
<td> 404</td>
</tr>
<tr>
<td><code>new</code>     </td>
<td> rendered <code>new</code>                 </td>
<td> 404</td>
</tr>
<tr>
<td><code>create</code>  </td>
<td> redirect <code>show</code> of new object  </td>
<td> rendered <code>new</code></td>
</tr>
<tr>
<td><code>edit</code>    </td>
<td> rendered <code>edit</code>                </td>
<td> 404</td>
</tr>
<tr>
<td><code>update</code>  </td>
<td> redirect <code>show</code> of object      </td>
<td> rendered <code>edit</code></td>
</tr>
<tr>
<td><code>destroy</code> </td>
<td> rendered <code>index</code>               </td>
<td> </td>
</tr>
</tbody>
</table>



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