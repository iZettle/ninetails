require "rails_helper"

module Ninetails
  class TestController < NinetailsController
    def index
      render json: {
        foo_bar: "baz_box",
        hello_world: {
          this_is_dog_fort: "Checking in"
        }
      }
    end

    def show
      render text: "foo_bar"
    end
  end
end

class DummyController < ActionController::Base
  def index
    render json: {
      this_is_a_key: "thanks"
    }
  end
end

describe "Key conversion middleware" do

  # Add the Ninetails::TestController and DummyController stuff to routes
  before do
    Ninetails::Engine.routes.send(:eval_block, -> {
      get "/test", to: "test#index"
      get "/test/foo", to: "test#show"
    })

    Dummy::Application.routes.send(:eval_block, -> {
      get "/dummy", to: "dummy#index"
    })
  end

  describe "when Ninetails::Config.key_style is camelcase" do
    before do
      Ninetails::Config.key_style = :camelcase
    end

    it "should convert all keys to camelcase" do
      get "/test"
      expect(json).to have_key "fooBar"
      expect(json["helloWorld"]).to have_key "thisIsDogFort"
    end

    it "should not modify non-json responses" do
      get "/test/foo"
      expect(response.body).to eq "foo_bar"
    end

    it "should not modify responses from outside of the Ninetails engine" do
      get "/dummy"
      expect(json).to have_key "this_is_a_key"
    end
  end

  describe "when Ninetails::Config.key_style is underscore" do
    before do
      Ninetails::Config.key_style = :underscore
    end

    it "should not modify any response from Ninetails" do
      get "/test"
      expect(json).to have_key "foo_bar"
    end

    it "should not modify any response from the parent app" do
      get "/dummy"
      expect(json).to have_key "this_is_a_key"
    end
  end

end
