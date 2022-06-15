# ActiveDecorator [![Build Status](https://github.com/amatsuda/active_decorator/actions/workflows/main.yml/badge.svg)](https://github.com/amatsuda/active_decorator/actions) [![Code Climate](https://codeclimate.com/github/amatsuda/active_decorator/badges/gpa.svg)](https://codeclimate.com/github/amatsuda/active_decorator)

A simple and Rubyish view helper for Rails 4, Rails 5, Rails 6, and Rails 7. Keep your helpers and views Object-Oriented!


## Features ##

1. automatically mixes decorator module into corresponding model only when:
   1. passing a model or collection of models or an instance of ActiveRecord::Relation from controllers to views
   2. rendering partials with models (using `:collection` or `:object` or `:locals` explicitly or implicitly)
   3. fetching already decorated Active Record model object's association
2. the decorator module runs in the model's context. So, you can directly call any attributes or methods in the decorator module
3. since decorators are considered as sort of helpers, you can also call any ActionView's helper methods such as `content_tag` or `link_to`


## Supported versions ##

* Ruby 2.1.x, 2.2.x, 2.3.x, 2.4.x, 2.5.x, 2.6.x, 2.7.x, 3.0.x, 3.1.x, and 3.2 (trunk)

* Rails 4.2.x, 5.0, 5.1, 5.2, 6.0, 6.1, 7.0, and 7.1 (edge)


## Supported ORMs ##

ActiveRecord, ActiveResource, and any kind of ORMs that uses Ruby Objects as model objects


## Usage ##

1. bundle 'active_decorator' gem
2. create a decorator module for each AR model. For example, a decorator for a model `User` should be named `UserDecorator`.
You can use the generator for doing this ( `% rails g decorator user` )
3. Then it's all done. Without altering any single line of the existing code, the decorator modules will be automatically mixed into your models only in the view context.


## Examples ##

### Auto-decorating via `render` ###

* Model
```ruby
class Author < ActiveRecord::Base
  # first_name:string last_name:string
end
```

* Controller
```ruby
class AuthorsController < ApplicationController
  def show(id)  # powered by action_args
    @author = Author.find id
  end
end
```

* Decorator
```ruby
module AuthorDecorator
  def full_name
    "#{first_name} #{last_name}"
  end
end
```

* View
```erb
<%# @author here is auto-decorated in between the controller and the view %>
<p><%= @author.full_name %></p>
```

### Auto-decorating via AR model's associated objects ###

* Models
```ruby
class Author < ActiveRecord::Base
  # name:string
  has_many :books
end

class Book < ActiveRecord::Base
  # title:string url:string
  belongs_to :author
end
```

* Controller
```ruby
class AuthorsController < ApplicationController
  def show(id)
    @author = Author.find id
  end
end
```

* Decorator
```ruby
module BookDecorator
  def link
    link_to title, url
  end
end
```

* View
```erb
<p><%= @author.name %></p>
<ul>
<% @author.books.order(:id).each do |book| %>
  <%# `book` here is auto-decorated because @author is a decorated instance %>
  <li><%= book.link %></li>
<% end %>
</ul>
```

### Using ActiveDecorator outside of Action View ###

Sometimes you may want to use decorators outside of Action View, for example,
for background tasks for ActiveJob.
For such use case, ActiveDecorator module provides `run_with` method
that takes some kind of Action View and a block.

```ruby
ActiveDecorator::ViewContext.run_with ApplicationController.new.view_context do
  ## perform some heavy jobs here
end
```


## Testing

You can test a decorator using your favorite test framework by decorating the model instance with

```ruby
ActiveDecorator::Decorator.instance.decorate(model_instance)
```

Considering an `Organization` model and its simple decorator:

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
