class Ninetails::SeedGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
  argument :type, type: :string
  argument :name, type: :string, require: false
  argument :sections, type: :array, required: false, default: []

  def create_seed
    if type == "Page"
      template "page_seed.rb", "seeds/pages/#{name}.rb"
    else
      template "layout_seed.rb", "seeds/layouts/#{name}.rb"
    end
  end

  private

  def content_sections(prefix)
    sections.collect do |section|
      section_template section, prefix
    end
  end

  def section_template(section_class, prefix)
  <<-EOF
  #{prefix}.content_section Section::#{section_class} do |section|
#{section_elements(section_class)}
  end

  EOF
  end

  def section_elements(section_class_name)
    section_class = "Section::#{section_class_name}".safe_constantize
    puts "Unknown section '#{section_class_name}'!" unless section_class.present?

    generated_elements = []

    section_class.elements.collect do |element|
      element.properties_structure.except(:type, :reference).tap do |structure|
        structure.each do |property, values|
          structure[property] = values.except :reference
        end

        if element.count == :multiple
          generated_elements << "    section.#{element.name} [{ #{print_props(structure)} }]"
        else
          generated_elements << "    section.#{element.name} #{print_props(structure)}"
        end
      end
    end

    generated_elements.join "\n"
  end

  def print_props(props)
    props.collect do |key, value|
      %{#{key}: { #{print_element(value)} }}
    end.join("\n")
  end

  def print_element(element)
    if element.is_a? Hash
      element.collect do |key, value|
        %{#{key}: #{print_element(value)}}
      end.join(", ")
    else
      element.nil? ? '""' : element
    end
  end

end
