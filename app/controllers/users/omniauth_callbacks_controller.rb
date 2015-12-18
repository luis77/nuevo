class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  # More info at:
  # https://github.com/plataformatec/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
  include ApplicationHelper
    def facebook
      # Attempt to find the User
      @user = User.find_for_facebook_oauth(
        request.env["omniauth.auth"], 
        current_user
      )
      #auth = request.env["omniauth.auth"]
      #raise auth.to_yaml #podemos ver los datos que nos ofrece facebook
      
      if @user.persisted?
        sign_in_and_redirect @user, 
          :event => :authentication 
        set_flash_message(:notice, 
          :success, 
          :kind => "Facebook") if is_navigational_format?
      else
        redirect_to new_user_registration_url
      end
    end
    def passthru
      render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
    end
end
