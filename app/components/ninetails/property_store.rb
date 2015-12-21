module Ninetails
  module PropertyStore
    extend ActiveSupport::Concern

    included do
      include Virtus.model
      include ActiveModel::Validations
    end

    class_methods do
      def property(name, options)
        if options.is_a? Hash
          attribute name, Object
        else
          attribute name, options
        end

        properties << Ninetails::PropertyType.new(name, options)
      end

      def properties
        @properties ||= []
      end
    end

  end
end
