![Ninetails](http://i.imgur.com/jv28Kg3.png)

[![Build Status](https://travis-ci.org/iZettle/ninetails.svg)](https://travis-ci.org/iZettle/ninetails)
[![Code Climate](https://codeclimate.com/github/iZettle/ninetails/badges/gpa.svg)](https://codeclimate.com/github/iZettle/ninetails)
[![Test Coverage](https://codeclimate.com/github/iZettle/ninetails/badges/coverage.svg)](https://codeclimate.com/github/iZettle/ninetails/coverage)

Ninetails is a simple Rails engine to create an API for a content management system to run on. It is designed on the idea of a CMS which is limited in scope in that not all aspects of a page should be editable. Instead, you can define Sections, Elements, and Properties which are editable and can then be loaded in and styled in a reliable manner. It gives you the control to decide exactly what should and what should not be editable in your project.

*WARNING: Ninetails is very much a work in progress and is not ready to be fully used yet!*

# Getting started

Ninetails is a mountable Rails engine, so it needs to be loaded into your app. You app is also where you will define your components which Ninetails should expose. Start by adding it to your Gemfile:

```
gem "ninetails"
```

Then you need to mount the engine in `config/routes.rb`

```ruby
Rails.application.routes.draw do
  mount Ninetails::Engine, at: "/api"
end
```

## Thinking in sections

To configure Ninetails for your CMS, you must define Sections, Elements, and Properties. Let's look at what each one means first. Imagine we were going to model the following section from [izettle.com](https://www.izettle.com):

![Billboard](http://i.imgur.com/LFqCSpo.png)

At the highest level, we have two sections here; the navigation bar at the top, and a billboard beneath it:

![Sections](http://i.imgur.com/Ab5sAhW.png)

Lets concentrate on the billboard section now. It has a bunch of elements:

![Elements](http://i.imgur.com/sVokxCD.png)

Each of those elements has properties. The Headline element can use a very simple Text property which just contains a string. The Background element needs an Image property which will have the image src, and an alt tag. The Card icons will be similar to the Background element, but will use an array of Image properties. Finally, the SignupButton will need a Link property which will have text for the link, a title attribute, and a url for the link to point to.

![Properties](http://i.imgur.com/64Fog28.png)

## Setting up Sections, Elements, and Properties

Let's build up the Section, Elements, and Properties from the examples above from the bottom up. These will live in `app/components/section_templates`, `app/components/elements`, and `app/components/properties`.

### Properties

```ruby
# app/components/properties/text.rb
module Property
  class Text < Ninetails::Property
    property :text, String
  end
end
```

```ruby
# app/components/properties/image.rb
module Property
  class Image < Ninetails::Property
    property :src, String
    property :alt, String
  end
end
```

```ruby
# app/components/properties/link.rb
module Property
  class Link < Ninetails::Property
    property :url, String
    property :title, String
    property :text, String
  end
end
```

### Elements

```ruby
# app/components/elements/text.rb
module Element
  class Text < Ninetails::Element
    property :content, Property::Text
  end
end
```

```ruby
# app/components/elements/text.rb
module Element
  class Button < Ninetails::Element
    property :link, Property::Link
  end
end
```

```ruby
# app/components/elements/figure.rb
module Element
  class Figure < Ninetails::Element
    property :image, Property::Image
  end
end
```

### Section Templates

The section template pulls it all together:

```ruby
module SectionTemplate
  class Billboard < Ninetails::SectionTemplate
    located_in :body

    has_element :title, Element::Text
    has_element :background_image, Element::Figure
    has_element :signup_button, Element::Button

    has_many_elements :supported_card_icons, Element::Figure
  end
end
```

## Looking at the result of your SectionTemplate

Assuming you have Ninetails mounted at "/api" on your application, you can now list the templates which you have configured at "/api/section_templates". You you load up "/api/section_templates/Billboard", you should now be able to see an empty JSON structure for the template you just setup. It should look something like this:

```json
{
  "name": "",
  "type": "Billboard",
  "tags": {
    "position": "body"
  },
  "elements": {
    "title": {
      "type": "Text",
      "reference": "a3087414-b1d3-459a-8cd1-bb1d502e9345",
      "content": {
        "text": ""
      }
    },
    "background_image": {
      "type": "Figure",
      "reference": "85556d83-6212-453f-8e5b-6fbcd8f72237",
      "image": {
        "src": "",
        "alt": ""
      }
    },
    "signup_button": {
      "type": "Button",
      "reference": "c9557fa1-5dc9-462f-9dc7-8ff05c65db2b",
      "link": {
        "url": "",
        "title": "",
        "text": ""
      }
    },
    "supported_card_icons": [
      {
        "type": "Figure",
        "reference": "33c01aab-94f9-4217-8f57-aa9add7ed73f",
        "image": {
          "src": "",
          "alt": ""
        }
      }
    ]
  }
}
```

# Creating pages

TODO

# Creating revisions

TODO

# Publishing pages

TODO

# Validating properties

TODO
