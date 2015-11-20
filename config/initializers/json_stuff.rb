Jbuilder.key_format camelize: :lower

module StringToApi
  def to_api
    camelize :lower
  end
end

String.send :prepend, StringToApi
