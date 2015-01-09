module ActiveDecorator
  module ORM
    module Mongoid
      def first
        decorate super
      end

      def last
        decorate super
      end

      def each(&block)
        super do |document|
          yield decorate(document)
        end
      end

      def map(&block)
        super do |document|
          yield decorate(document)
        end
      end

      private

      def decorate(object)
        ActiveDecorator::Decorator.instance.decorate(object)
      end
    end
  end
end
