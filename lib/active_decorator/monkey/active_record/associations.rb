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

        if Rails.version.to_f < 5.1
          module CollectionAssociation
            private
            def first_nth_or_last(*)
              ActiveDecorator::Decorator.instance.decorate_association(owner, super)
            end
          end
        end

        module CollectionProxy
          def take(*)
            ActiveDecorator::Decorator.instance.decorate_association(@association.owner, super)
          end

          if Rails.version.to_f >= 5.1
            def last(*)
              ActiveDecorator::Decorator.instance.decorate_association(@association.owner, super)
            end

            private

            def find_nth_with_limit(*)
              ActiveDecorator::Decorator.instance.decorate_association(@association.owner, super)
            end

            def find_nth_from_last(*)
              ActiveDecorator::Decorator.instance.decorate_association(@association.owner, super)
            end
          end
        end

        module CollectionAssociation
          private

          def build_record(*)
            ActiveDecorator::Decorator.instance.decorate_association(@owner, super)
          end
        end
      end

      module AssociationRelation
        def spawn(*)
          ActiveDecorator::Decorator.instance.decorate_association(@association.owner, super)
        end
      end
    end
  end
end
