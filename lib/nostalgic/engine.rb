module Nostalgic
  class Engine < ::Rails::Engine
    isolate_namespace Nostalgic

    initializer 'nostalgic.assets.precompile' do |app|
      app.config.assets.precompile += %w[nostalgic_manifest.js]
    end
  end
end
