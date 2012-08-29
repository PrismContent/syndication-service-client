module SyndicationService
  class MainContentTemplate
    require File.expand_path(File.dirname(__FILE__), 'main_content_template_persistence')

    include Prism::Serializers::JSON
    # not including the validations because this class is read-only

    @@attributes = [:id, :background_image_url, :opted_out]
    attr_accessor *@@attributes

    class << self
      def find(account_id)
        SyndicationService::MainContentTemplatePersistence.find_for_account_id account_id
      end

      def find_for_announcement(account_id)
        SyndicationService::MainContentTemplatePersistence.find_for_account_id account_id, :announcement => true
      end
    end

    def initialize(template_attr)
      template_attr ||= {}
      template_attr = HashWithIndifferentAccess.new(template_attr)

      self.attributes = template_attr.slice *@@attributes
    end

    def opt_out(account_id)
      SyndicationService::MainContentTemplatePersistence.opt_out self, account_id
    end

    def opt_in(account_id)
      SyndicationService::MainContentTemplatePersistence.opt_in self, account_id
    end

    def opted_out?
      read_attribute_for_validation(:opted_out)
    end

    def attributes
      @@attributes.inject(HashWithIndifferentAccess.new) do |attrs, key|
        attrs.merge key => read_attribute_for_validation(key)
      end
    end

    def attributes=(attrs)
      attrs.each_pair{|k,v| send "#{k}=", v}
    end

    def read_attribute_for_validation(key)
      send key
    end

    def service_errors
      @service_errors ||= {}
    end

    private
      def service_errors=(errors)
        @service_errors = errors
      end
  end
end
