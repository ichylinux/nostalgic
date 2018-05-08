module Nostalgic
  class Railtie < ::Rails::Railtie

    ActiveSupport.on_load :active_record do
      require_relative 'nostalgic_attr'
      include Nostalgic::NostalgicAttr
    end

  end
end
