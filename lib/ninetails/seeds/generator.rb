module Ninetails
  module Seeds
    class Generator

      attr_accessor :container_type

      def self.layouts
        @layouts ||= {}
      end

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
        generate_container(name, Ninetails::Layout, &block).tap do |layout|
          layouts[name] = layout
        end
      end

      def self.generate_page(&block)
        generate_container nil, Ninetails::Page, &block
      end

      def self.generate_container(name, container_type, &block)
        c = new container_type: container_type
        c.container.create_current_revision
        block.call c
        c.container.save!
        c.container.current_revision.update_attributes container_id: c.container.id
        c.container
      end

      def initialize(container_type:)
        @container_type = container_type
      end

      def container
        @container ||= container_type.new
      end

      def content_section(section_class, &block)
        SectionBuilder.new(container.current_revision, section_class).build &block
      end

      def layout(layout)
        if layout.is_a? Symbol
          container.layout = self.class.layouts[layout]
        else
          container.layout = Ninetails::Layout.find layout
        end
      end

      def method_missing(name, *args, &block)
        # Filter methods which should be set on the revision instead of the container
        if [:url, :locale, :name].include? name.to_sym
          container.current_revision.public_send "#{name}=", *args
        else
          container.public_send "#{name}=", *args
        end
      end
    end
  end
end
