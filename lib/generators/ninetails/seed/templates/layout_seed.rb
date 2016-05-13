Ninetails::Seeds::Generator.generate_layout <%= name.to_sym %> do |layout|
  name "Name this layout"

<%- content_sections("layout").each do |section| -%>
<%= section -%>
<%- end -%>
end
