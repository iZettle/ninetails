module SectionHelpers

  def document_head_section(title: "Title text", description: "Description text")
    {
      "name": "",
      "type": "DocumentHead",
      "tags": {
        "position": "head"
      },
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
