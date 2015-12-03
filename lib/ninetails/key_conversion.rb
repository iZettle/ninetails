module Ninetails
  class KeyConversion

    def initialize(app)
      @app = app
    end

    def call(env)
      @status, @headers, @response = @app.call(env)

      if @response.respond_to? :body
        [@status, @headers, [modify_keys(@response.body)]]
      else
        [@status, @headers, @response]
      end
    end

    def modify_keys(body)
      if @headers["Content-Type"].include?("application/json") && Ninetails::Config.key_style == :camelcase
        body = JSON.parse(body).convert_keys -> (key) { key.camelcase :lower }
        body.to_json
      else
        body
      end
    end

  end
end
