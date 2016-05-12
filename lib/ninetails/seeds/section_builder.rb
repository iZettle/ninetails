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
        block.call self if block_given?
        section.save!
      end

      def method_missing(name, *args, &block)
        if args.first.is_a? Hash
          update_element name, args.first.with_indifferent_access
        else
          update_elements_array name, args.first
        end
      end

      private

      def update_element(key, values, modify_section: true)
        element_clone = section.elements.dup[key.to_s]
        binding.pry
        element_clone = element_clone.first if element_clone.is_a? Array

        values.each do |element, property|
          values[element].each do |element_to_modify, value|
            element_clone[element][element_to_modify] = value
          end
        end

        if modify_section
          section.elements[key.to_s] = element_clone
        else
          element_clone
        end
      end

      def update_elements_array(key, values)
        element = section.elements[key.to_s]

        new_elements = values.collect do |element_values|
          a = update_element key, element_values.with_indifferent_access, modify_section: false
          puts a
          a
        end
        binding.pry

        section.elements[key.to_s] = new_elements
      rescue
        binding.pry
      end

    end
  end
end
