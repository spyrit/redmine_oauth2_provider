module RedmineOauth2Provider
  module PatchAuth

    module InstanceMethods
      def oauth_token_from_request
        if params[:oauth_token].present?
          params[:oauth_token].to_s
        end
      end

      def find_current_user_with_oauth
        return find_current_user_without_oauth unless api_request? && (oauth_key = oauth_token_from_request)
        token = Songkick::OAuth2::Provider.access_token(:implicit, ['read_user_informations'], request)
        user = token.owner
      end
    end

    def self.included(receiver) # :nodoc:
      receiver.send :include, InstanceMethods
      receiver.class_eval do
        alias_method :find_current_user_without_oauth, :find_current_user
        alias_method :find_current_user, :find_current_user_with_oauth
      end
    end

  end
end
