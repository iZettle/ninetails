Ninetails::Seeds::Generator.generate_page do |page|
  name "Name this page"
  url "<%= name %>"
  # layout :layout_name

<%- content_sections("page").each do |section| -%>
<%= section -%>
<%- end -%>
end
