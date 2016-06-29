module SectionHelpers

  def document_head_section(title: "Title text", description: "Description text", variant: nil)
    {
      "name": "",
      "type": "DocumentHead",
      "variant": variant,
      "elements": {
        "title": {
          "type": "Text",
          "content": {
            "text": title
          }
        },
        "description": {
          "type": "Meta",
          "content": {
            "text": description
          }
        }
      }
    }
  end

end
