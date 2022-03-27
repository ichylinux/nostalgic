module Nostalgic
  module NostalgicAttr
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

    class_methods do

      def nostalgic_attrs
        @@_nostalgic_attrs ||= {}
        @@_nostalgic_attrs[self] ||= []
      end

      def nostalgic_attr(*attrs)
        attrs.each do |attr|

          model_type = self.model_name.to_s

          class_eval <<-METHODS, __FILE__, __LINE__ + 1
            nostalgic_attrs << attr.to_sym unless nostalgic_attrs.include?(attr.to_sym)

            has_many :#{attr.to_s.pluralize}, -> {where(model_type: model_type, name: '#{attr}').order('effective_at desc')}, class_name: 'Nostalgic::Attr', foreign_key: 'model_id'
            accepts_nested_attributes_for :#{attr.to_s.pluralize}, allow_destroy: true

            attr_accessor :#{attr}_effective_at

            def #{attr}_on(date)
              return self.#{attr} unless date.present?

              na = Nostalgic::Attr.where(model_type: self.class.name, model_id: self.id, name: '#{attr}')
              na = na.where('effective_at <= ?', date).order('effective_at desc').first
              na ? na.value : self.#{attr}
            end

            alias_method :#{attr}_at, :#{attr}_on
          METHODS
        end
      end

      def belongs_to(name, scope = nil, **options)
        super(name, scope, **options.except(:nostalgic))

        if options.fetch(:nostalgic, false)
          foreign_key = options.fetch(:foreign_key, "#{name}_id")
          nostalgic_attr foreign_key

          class_eval <<-METHODS, __FILE__, __LINE__ + 1
            def #{name}_on(date)
              return self.#{name} unless date.present?

              '#{name}'.classify.constantize.find_by_id(#{foreign_key}_on(date))
            end

            alias_method :#{name}_at, :#{name}_on
          METHODS
        end
      end

    end
  end
end