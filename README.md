![Ninetails](http://i.imgur.com/jv28Kg3.png)

[![Build Status](https://travis-ci.org/iZettle/ninetails.svg)](https://travis-ci.org/iZettle/ninetails)
[![Code Climate](https://codeclimate.com/github/iZettle/ninetails/badges/gpa.svg)](https://codeclimate.com/github/iZettle/ninetails)
[![Test Coverage](https://codeclimate.com/github/iZettle/ninetails/badges/coverage.svg)](https://codeclimate.com/github/iZettle/ninetails/coverage)

Ninetails is a simple Rails engine to create an API for a content management system to run on. It is designed on the idea of a CMS which is limited in scope in that not all aspects of a page should be editable. Instead, you can define Sections, Elements, and Properties which are editable and can then be loaded in and styled in a reliable manner. It gives you the control to decide exactly what should and what should not be editable in your project.

**WARNING: Ninetails is very much a work in progress and is not ready to be fully used yet!**

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

## Usage guide

* [Thinking in sections](https://github.com/iZettle/ninetails/wiki/Thinking-in-sections)
* [Creating pages](https://github.com/iZettle/ninetails/wiki/Creating-pages)
* [Publishing pages](https://github.com/iZettle/ninetails/wiki/Publishing-pages)
* [Validating properties](https://github.com/iZettle/ninetails/wiki/Validating-properties)
