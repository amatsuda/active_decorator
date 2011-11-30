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
        ActiveDecorator.decorate_if_model r
      end
    end
  end

  private
  def self.decorate_all(models)
    return models if models.empty?

    d = decorator_for models.first.class
    return unless d

    models.each do |m|
      m.extend d unless m.is_a? d
    end
  end

  def self.decorate(model)
    d = decorator_for model.class
    return unless d
    model.extend d unless model.is_a? d
  end

  def self.decorator_for(model_class)
    decorator_name = "#{model_class.name}Decorator"
    d = decorator_name.constantize
    rescue NameError
  end
end
