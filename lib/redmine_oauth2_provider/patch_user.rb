module RedmineOauth2Provider::PatchUser
  module RedmineSocialExtends
    module UserExtension
      module ClassMethods

      end

      module InstanceMethods

      end

      def self.included(receiver)
        receiver.extend         ClassMethods
        receiver.send :include, InstanceMethods
        receiver.class_eval do
          #OAuth2 Provider-Mixins
          include Songkick::OAuth2::Model::ResourceOwner
          include Songkick::OAuth2::Model::ClientOwner

        end
      end
    end

    module UsersController
      module ClassMethods

      end

      module InstanceMethods

      end

      def self.included(receiver)
        receiver.extend         ClassMethods
        receiver.send :include, InstanceMethods
        receiver.class_eval do

          def oauth_get_user_information
            verify_access :read_user_informations do |user|
              user = {:user_id => user.id, :login => user.login}
              render :json => user
            end
          end


          private

            def verify_access(scope)
              token = Songkick::OAuth2::Provider.access_token(:implicit, [scope.to_s], request)
              user = token.owner

              unless token.valid?
                return render_403
              else
                yield user
              end
            end

        end
      end
    end
  end
end
