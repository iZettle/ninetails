module Ninetails

  # Creates an abstract reference to another class which can then be used
  # when a property is deserialized to modify the property value. This allows
  # you to create a very basic relation property.
  class PropertyLink

    attr_accessor :name, :link

    def initialize(name, link)
      @name = name
      @link = link
    end

    # Replace the placeholder values in the ++link[:where]++ conditions with
    # the actual values from the ++values++ hash.
    #
    # For example, if the ++link[:where]++ was { id: :foo_bar }, and the ++values++
    # hash was { foo_bar: 123 }, then this would return { id: 123 }
    def select_conditions(values)
      link[:where].clone.tap do |conditions|
        conditions.each do |linked_column, property_name|
          conditions[linked_column] = values.fetch(property_name, nil)
        end
      end
    end

    # Pass the values hash through the select_conditions method, then use it on the ++:from++
    # link object to find the related instance, and finally use the ++:serialize_as++ value to
    # fetch the desired attribute.
    #
    # So, given a PropertyLink with a name of :page_id, and a link of which looks like this
    #   { serialize_as: :url, from: Ninetails::Page, where: { id: :page_id }}
    #
    # Calling ++deconstruct(123)++ would try to return the url of the Ninetails::Page with id 123.
    def deconstruct(values)
      link[:from].find_by(select_conditions(values)).send link[:serialize_as]
    end

  end
end
