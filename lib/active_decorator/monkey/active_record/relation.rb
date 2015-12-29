class ActiveRecord::Relation
  def to_a_with_decorator
    to_a_without_decorator.tap do |arr|
      ActiveDecorator::Decorator.instance.decorate arr
    end
  end
  alias_method_chain :to_a, :decorator
end
