module ActiveDecorator
  def self.decorate_if_model(obj)
    case obj
    when ActiveRecord::Base
      ActiveDecorator.decorate obj
    when ActiveRecord::Relation
      class << obj
        def to_a_with_decorator
          arr = to_a_without_decorator
          ActiveDecorator.decorate_all arr
        end
        alias_method_chain :to_a, :decorator
      end
    when Array
      obj.each do |r|
        ActiveDecorator.decorate r
      end
    end
  end

  def self.decorate_all(models)
    return if models.empty?
    decorator_name = "#{models.first.class.name}Decorator"
    k = decorator_name.constantize
    models.each do |m|
      m.extend k unless m.is_a? k
    end
    rescue NameError
  end

  def self.decorate(model)
    decorator_name = "#{model.class.name}Decorator"
    k = decorator_name.constantize
    model.extend k unless model.is_a? k
    rescue NameError
  end
end
