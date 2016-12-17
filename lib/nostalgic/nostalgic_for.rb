module Nostalgic
  module NostalgicFor
    extend ActiveSupport::Concern

    included do
      after_find :load_current_value
      after_save :save_nostalgic_attrs!
    end

    private

    def load_current_value
      Array(self.class.nostalgic_attrs).each do |attr|
        current = self.__send__(attr.to_s.pluralize).where('effective_at <= ?', Date.today).first
        if current
          self.__send__("#{attr}=", current.value)
          self.__send__("#{attr}_effective_at=", current.effective_at)
        else
          if self.respond_to?(:created_at) and self.created_at.present?
            self.__send__("#{attr}_effective_at=", self.created_at.to_date)
          end
        end
      end
    end

    def save_nostalgic_attrs!
      Array(self.class.nostalgic_attrs).each do |attr|
        effective_at = self.__send__("#{attr}_effective_at")
        next unless effective_at.present?

        na = Nostalgic::Attr.where(:model_type => self.class.name, :model_id => self.id, :name => attr, :effective_at => effective_at).first
        na ||= Nostalgic::Attr.new(:model_type => self.class.name, :model_id => self.id, :name => attr, :effective_at => effective_at)
        na.value = self.__send__(attr)
        na.save!
      end
    end

    module ClassMethods
      attr_accessor :nostalgic_attrs

      def belongs_to(name, scope = nil, options = {})
        super
        if options.fetch(:nostalgic, false)
          foreign_key = options.fetch(:foreign_key, "#{name}_id")
          nostalgic_for foreign_key
        end
      end

      def nostalgic_for(*attrs)
        self.nostalgic_attrs ||= []

        attrs.each do |attr|
          next if self.nostalgic_attrs.include?(attr.to_sym)
          self.nostalgic_attrs << attr.to_sym

          model_name = self.model_name.to_s

          class_eval <<-METHODS, __FILE__, __LINE__ + 1
            has_many :#{attr.to_s.pluralize}, -> {where(:model_type => model_name, :name => '#{attr}').order('effective_at desc')}, :class_name => 'Nostalgic::Attr', :foreign_key => 'model_id'
            accepts_nested_attributes_for :#{attr.to_s.pluralize}, :allow_destroy => true

            attr_accessor :#{attr}_effective_at

            def #{attr}_on(date)
              raise ArgumentError.new if date.nil?

              na = Nostalgic::Attr.where(:model_type => self.class.name, :model_id => self.id, :name => '#{attr}')
              na = na.where('effective_at <= ?', date).order('effective_at desc').first
              na ? na.value : self.#{attr}
            end

            alias_method :#{attr}_at, :#{attr}_on

          METHODS
        end
      end

    end
  end
end