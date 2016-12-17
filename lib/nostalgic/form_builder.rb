require 'action_view'

class ActionView::Helpers::FormBuilder
  include ActionView::Helpers::AssetTagHelper

  def nostalgic_text_field(method, options = {})
    @template.render 'nostalgic/text_field', :f => self, :attr => method, :css_class => options[:class]
  end

  def nostalgic_collection_select(method, collection, value_method, text_method, options = {}, html_options = {})
    @template.render 'nostalgic/collction_select',
        :f => self, :attr => method, :collection => collection, :value_method => value_method, :text_method => text_method,
        :options => options, :html_options => html_options
  end

end