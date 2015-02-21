# ActiveDecorator

A simple and Rubyish view helper for Rails 3 and Rails 4. Keep your helpers and views Object-Oriented!


## Features ##

1. automatically mixes decorator module into corresponding model only when:
  1. passing a model or collection of models or an instance of ActiveRecord::Relation from controllers to views
  2. rendering partials with models (using `:collection` or `:object` or `:locals` explicitly or implicitly)
2. the decorator module runs in the model's context. So, you can directly call any attributes or methods in the decorator module
3. since decorators are considered as sort of helpers, you can also call any ActionView's helper methods such as `content_tag` or `link_to`


## Supported versions ##

Rails 3.0.x, 3.1.x, 3.2.x, 4.0.x, 4.1.x, 4.2.x, and 5.0 (edge)


## Supported ORMs ##

ActiveRecord, ActiveResource, and any kind of ORMs that uses Ruby Objects as model objects


## Usage ##

1. bundle 'active_decorator' gem
2. create a decorator module for each AR model. For example, a decorator for a model `User` should be named `UserDecorator`.
You can use the generator for doing this ( `% rails g decorator user` )
3. Then it's all done. Without altering any single line of the existing code, the decorator modules will be automatically mixed into your models only in the view context.


## Examples ##

```ruby
# app/models/user.rb
class User < ActiveRecord::Base
  # first_name:string last_name:string website:string
end

# app/decorators/user_decorator.rb
module UserDecorator
  def full_name
    "#{first_name} #{last_name}"
  end

  def link
    link_to full_name, website
  end
end

# app/controllers/users_controller.rb
class UsersController < ApplicationController
  def index
    @users = User.all
  end
end
```
```erb
# app/views/users/index.html.erb
<% @users.each do |user| %>
  <%= user.link %><br>
<% end %>
```

## Configuring the decorator suffix

By default, ActiveDecorator searches a decorator module named `target_class.name + "Decorator"`

If you would like a different rule, you can configure in your initializer.

```ruby
ActiveDecorator.configure do |config|
  config.decorator_suffix = 'Presenter'
end
```

## Contributing to ActiveDecorator ##

* Fork, fix, then send me a pull request.


## Copyright ##

Copyright (c) 2011 Akira Matsuda. See MIT-LICENSE for further details.
