## 1.1.1

* Improved ActionController::API support for Rails 5.0.x [@frodsan]

* Fixed "NameError: undefined local variable or method `view_context'" with ActionController::API or when rendering in controllers


## 1.1.0

* ActionController::API support [@frodsan]

* `ActiveDecorator::Decorator.instance.decorate` now returns the decorated object when the receiver was already a decorated object (it used to return `nil`) [@velonica1997]

* Update decorator_spec.rb syntax to respect RSpec 3 style [@memoht]

* Fixed namespace for TestUnit generator with some refactorings [@yhirano55]
