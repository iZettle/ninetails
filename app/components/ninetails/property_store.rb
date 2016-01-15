module Ninetails
  module PropertyStore
    extend ActiveSupport::Concern

    included do
      include Virtus.model
      include ActiveModel::Validations

      attribute :note, String
    end

    class_methods do
      def property(name, type)
        attribute name, type
        properties << Ninetails::PropertyType.new(name, type)
      end

      def properties
        @properties ||= []
      end
    end

  end
end
