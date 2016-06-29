module Ninetails
  module Seeds
    class SectionBuilder
      attr_accessor :revision, :section_class, :content_section

      def initialize(revision, section_class)
        @revision = revision
        @section_class = section_class
        @content_section = Ninetails::ContentSection.new type: section_class.to_s.demodulize
      end

      def build(&block)
        block.call self if block_given?
        content_section.save!
        revision.sections << content_section
      end

      def method_missing(method, *args, &block)
        if element_definition(method).present?
          add_element_to_section method, args.first
        elsif content_section.respond_to? "#{method}="
          content_section.public_send "#{method}=", *args
        else
          raise "Unknown attribute #{method} on #{section_class}. Check your seeds!"
        end
      end

      private

      def add_element_to_section(element_name, values)
        content_section.elements[element_name.to_s] = make_hash_accessible(values)
      end

      def element_definition(key)
        section_class.elements.find { |element| element.name == key }
      end

      def make_hash_accessible(hash)
        if hash.is_a? Hash
          hash.with_indifferent_access
        elsif hash.is_a? Array
          hash.collect { |h| make_hash_accessible h }
        end
      end

    end
  end
end
