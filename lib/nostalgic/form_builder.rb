require 'action_view'

class ActionView::Helpers::FormBuilder
  include ActionView::Helpers::AssetTagHelper

  def nostalgic_text_field(method, options = {})
    @template.render 'nostalgic/text_field', :f => self, :attr => method, :css_class => options[:class]
  end

end