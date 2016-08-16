require 'action_view'

class ActionView::Helpers::FormBuilder
  include ActionView::Helpers::AssetTagHelper

  def nostalgic_text_field(method, options = {})
    text_field(method, append_nostalgic_clsss(options))
  end

  def nostalgic_number_field(method, options = {})
    number_field(method, append_nostalgic_clsss(options))
  end

  private

  def append_nostalgic_clsss(options = {})
    klass = options.fetch(:class, '').split
    klass.unshift('nostalgic')
    options.merge(:class => klass.join(' '))
  end

end