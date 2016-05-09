module Ninetails
  module Seeds
    class Generator

      attr_accessor :container_type

      # Run all seeds, but call layouts first so they can be used in pages
      def self.run
        Dir.glob(Rails.root.join("seeds", "layouts", "**", "*.rb")).each do |file|
          require file
        end

        Dir.glob(Rails.root.join("seeds", "pages", "**", "*.rb")).each do |file|
          require file
        end
      end

      def self.generate_layout(name, &block)
        generate_container name, Ninetails::Layout, &block
      end

      def self.generate_page(&block)
        generate_container nil, Ninetails::Page, &block
      end

      def self.generate_container(name, container_type, &block)
        c = new container_type: container_type
        c.container.create_current_revision
        c.instance_eval &block
        c.container.save!
        c.container
      end

      def initialize(container_type:)
        @container_type = container_type
      end

      def container
        @container ||= container_type.new
      end

      def content_section(section_class, &block)
        SectionBuilder.build container.current_revision, section_class, &block
      end

      def method_missing(name, *args, &block)
        container.public_send "#{name}=", *args
      end
    end
  end
end
