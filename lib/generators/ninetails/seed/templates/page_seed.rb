Ninetails::Seeds::Generator.generate_page do |page|
  page.name "Name this page"
  page.url "<%= name %>"
  page.locale "en_US"
  # page.layout :layout_name

<%- content_sections("page").each do |section| -%>
<%= section -%>
<%- end -%>
end
