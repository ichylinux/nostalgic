module Nostalgic
  module NostalgicFor
    extend ActiveSupport::Concern

    module ClassMethods
      
      def nostalgic_for(*attrs)
        attrs.each do |attr|
          class_eval <<-METHODS, __FILE__, __LINE__ + 1
            def #{attr}_at(datetime = nil)
              return self.#{attr} if datetime.nil?

              na = Nostalgic::Attr.where(:type => self.class.name, :model_id => self.id, :name => '#{attr}')
              na = na.where('effective_at <= ?', datetime).order('effective_at desc').first
              na ? na.value : self.#{attr}
            end
          METHODS
        end
      end

    end
  end
end