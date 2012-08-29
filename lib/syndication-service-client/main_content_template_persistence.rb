module SyndicationService
  class MainContentTemplatePersistence
    require File.expand_path(File.dirname(__FILE__), 'main_content_template')

    class << self
      def find_for_account_id(account_id, options={})
        target_url = options[:announcement] ? announcement_collection_url(account_id) : collection_url(account_id)
        response = Typhoeus::Request.get target_url

        if response.code == 200
          return main_content_templates_from(response)
        else
          return []
        end
      end

      def opt_in(main_content_template, account_id)
        response = Typhoeus::Request.delete instance_opt_out_url(main_content_template.id, account_id)
        if response.code == 200
          main_content_template.opted_out = false
          return true
        end
        false
      end

      def opt_out(main_content_template, account_id)
        response = Typhoeus::Request.put instance_opt_out_url(main_content_template.id, account_id)
        if response.code == 200
          main_content_template.opted_out = true
          return true
        end
        false
      end

      private
        def instance_opt_out_url(instance_id, account_id)
          "#{collection_url(account_id)}/#{instance_id}/opt_out"
        end

        def announcement_collection_url(account_id)
          "#{collection_url(account_id)}/announcements"
        end

        def collection_url(account_id)
          "http://#{SyndicationService::Config.host}/v1/accounts/#{account_id}/main_content_templates"
        end

        def main_content_templates_from(response)
          JSON.parse(response.body)['main_content_templates'].map(&:values).flatten.map{|attr| SyndicationService::MainContentTemplate.new attr}
        end
    end
  end
end
