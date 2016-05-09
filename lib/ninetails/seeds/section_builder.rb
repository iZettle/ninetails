module Ninetails
  module Seeds
    class SectionBuilder
      attr_accessor :section

      def self.build(revision, section_class, &block)
        section_definition = section_class.new.serialize
        section = revision.sections.new section_definition.only(:name, :type, :elements)
        new section, &block
      end

      def initialize(section, &block)
        @section = section
        instance_eval &block if block_given?
        section.save!
      end

      def method_missing(name, *args, &block)
        update_element name, args.first.with_indifferent_access
      end

      private

      def update_element(key, values)
        values.each do |element, property|
          values[element].each do |element_to_modify, value|
            section.elements[key.to_s][element][element_to_modify] = value
          end
        end
      end

    end
  end
end
