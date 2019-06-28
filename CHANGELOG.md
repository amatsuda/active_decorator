## 1.3.0

* Switched from Active Support `constantize` to Ruby's `const_get` when fetching decorator modules

* Switched `config` from ActiveSupport::Configurable to a simple Struct

* Association decoration now propagates from AssociationRelation to spawned Relations (e.g. `@post.comments.order(:id).each`)

* Dropped support for Rails 3.2, 4.0, and 4.1


## 1.2.0

* Decorate values in Hash recursively [@FumiyaShibusawa]


## 1.1.1

* Improved ActionController::API support for Rails 5.0.x [@frodsan]

* Fixed "NameError: undefined local variable or method `view_context'" with ActionController::API or when rendering in controllers


## 1.1.0

* ActionController::API support [@frodsan]

* `ActiveDecorator::Decorator.instance.decorate` now returns the decorated object when the receiver was already a decorated object (it used to return `nil`) [@velonica1997]

* Update decorator_spec.rb syntax to respect RSpec 3 style [@memoht]

* Fixed namespace for TestUnit generator with some refactorings [@yhirano55]
