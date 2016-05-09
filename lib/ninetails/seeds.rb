module Ninetails
  class Seeds

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

    def self.generate_container(name, container_type, &block)
      c = new container_type: Ninetails::Layout
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

    def name(name)
      container.name = name
    end

    def add_content_section(section_class)
      section_definition = section_class.new.serialize
      container.current_revision.sections.create section_definition.only(:name, :type, :elements)
    end

    def method_missing(name, *args, &block)
      binding.pry
    end

  end
end
