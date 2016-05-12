class Ninetails::SeedGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)
  argument :type, type: :string
  argument :url, type: :string
  argument :sections, type: :array, required: false

  def create_seed
    if type == "Page"
      template "page_seed.rb", "seeds/pages/#{url}.rb"
    end
  end

  private

  def content_sections(prefix)
    sections.collect do |section|
      section_template section, prefix
    end
  end

  def section_template(section_class, prefix)
  <<-RUBY
  #{prefix}.content_section Section::#{section_class} do |section|
    #{section_elements(section_class)}
  end
  RUBY
  end

  def section_elements(section_class)
    section = "Section::#{section_class}".safe_constantize.new

    elements = section.serialize[:elements].collect do |element_name, element|
      if element.is_a? Array
        binding.pry
      else
        props = element.except(:type, :reference)
      end

      props.each do |prop_name, values|
        props[prop_name] = values.except(:reference)
      end

      <<-RUBY
section.#{element_name} #{print_props(props)}
      RUBY
    end

    elements.join("\n")
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
