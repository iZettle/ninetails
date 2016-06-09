Ninetails::Seeds::Generator.generate_layout :<%= name %> do |layout|
  layout.name "Name this layout"
  layout.locale "en_US"

<%- content_sections("layout").each do |section| -%>
<%= section -%>
<%- end -%>
end
