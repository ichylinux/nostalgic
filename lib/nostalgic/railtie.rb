module Nostalgic
  class Railtie < ::Rails::Railtie

    initializer 'active_record_extension' do
      ActiveSupport.on_load :active_record do
        require_relative 'nostalgic_attr'
        include Nostalgic::NostalgicAttr
      end
    end

  end
end
