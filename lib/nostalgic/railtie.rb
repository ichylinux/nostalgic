module Nostalgic
  class Railtie < ::Rails::Railtie

    initializer 'active_record_extension' do
      ActiveSupport.on_load :active_record do
        require_relative 'nostalgic_for'
        include Nostalgic::NostalgicFor
      end
    end

  end
end
