Ninetails::Seeds::Generator.generate_page do |page|
  name "Name this page"
  url "<%= url %>"
  # layout :layout_name

<%- content_sections("page").each do |section| -%>
<%= section -%>
<%- end -%>
end
