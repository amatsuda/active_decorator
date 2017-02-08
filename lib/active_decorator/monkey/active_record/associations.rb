# frozen_string_literal: true
# A monkey-patch for Active Record that enables association auto-decoration.
module ActiveDecorator
  module Monkey
    module ActiveRecord
      module Associations
        module Association
          def target
            ActiveDecorator::Decorator.instance.decorate_association(owner, super)
          end
        end

        module CollectionAssociation
          # @see https://github.com/rails/rails/commit/03855e790de2224519f55382e3c32118be31eeff
          if Rails.version.to_f < 4.1
            def first_or_last(*args)
              ActiveDecorator::Decorator.instance.decorate_association(owner, super)
            end
          else
            def first_nth_or_last(*args)
              ActiveDecorator::Decorator.instance.decorate_association(owner, super)
            end
          end
        end
      end
    end
  end
end
