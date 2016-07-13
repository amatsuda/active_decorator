# ActiveDecorator [![Build Status](https://travis-ci.org/amatsuda/active_decorator.svg?branch=master)](https://travis-ci.org/amatsuda/active_decorator) [![Code Climate](https://codeclimate.com/github/amatsuda/active_decorator/badges/gpa.svg)](https://codeclimate.com/github/amatsuda/active_decorator)

A simple and Rubyish view helper for Rails 3, Rails 4 and Rails 5. Keep your helpers and views Object-Oriented!


## Features ##

1. automatically mixes decorator module into corresponding model only when:
  1. passing a model or collection of models or an instance of ActiveRecord::Relation from controllers to views
  2. rendering partials with models (using `:collection` or `:object` or `:locals` explicitly or implicitly)
2. the decorator module runs in the model's context. So, you can directly call any attributes or methods in the decorator module
3. since decorators are considered as sort of helpers, you can also call any ActionView's helper methods such as `content_tag` or `link_to`


## Supported versions ##

* Ruby 2.0.0, 2.1.x, 2.2.x, 2.3.x, and 2.4 (trunk)

* Rails 3.2.x, 4.0.x, 4.1.x, 4.2.x, 5.0, and 5.1 (edge)


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

## Decorating associated objects ##

ActiveDecorator *does not* automatically decorate associated objects. We recommend that you pass associated objects to `render` when decorated associated objects are needed.

```ruby
# app/models/blog_post.rb
class BlogPost < ActiveRecord::Base
  # published_at:datetime
end

# app/models/user.rb
class User < ActiveRecord::Base
  has_many :blog_posts
end

# app/decorators/blog_post_decorator.rb
module BlogPostDecorator
  def published_date
    published_at.strftime("%Y.%m.%d")
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
  <%= render partial: "blog_post", locals: { blog_posts: user.blog_posts } %><br>
<% end %>

# app/views/users/_blog_post.html.erb
<% blog_posts.each do |blog_post| %>
  <%= blog_post.published_date %>
<% end %>
```

## Testing

You can test a decorator using your favorite test framework by decorating the model instance with

```ruby
ActiveDecorator::Decorator.instance.decorate(model_instance)
```

Considering an `Organization` model and it's simple decorator:

```ruby
module OrganizationDecorator
  def full_name
    "#{first_name} #{last_name}"
  end
end
```

An RSpec test would look like:

```ruby
describe '#full_name' do
  it 'returns the full organization name' do
    organization = Organization.new(first_name: 'John', last_name: 'Doe')
    decorated_organization = ActiveDecorator::Decorator.instance.decorate(organization)

    expect(decorated_organization.full_name).to eq('John Doe')
  end
end
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
