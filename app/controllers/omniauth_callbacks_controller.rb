class OmniauthCallbacksController <ApplicationController
	def facebook
		auth = request.env["omniauth.auth"]#el hash con la info del usuario se encuentra en omniauth.auth q contiene la informacion para autenticar al usuario
		#raise auth.to_yaml 
		data = {
			nombre: auth.info.first_name, #infornacion que requeriremos del usuario
			apellido: auth.info.last_name,
			username: auth.info.nickname,
			email: auth.info.email,
			provider: auth.provider, #proveedor
			uid: auth.uid #identificador
		}

		@user = User.find_or_create_by_omniauth(data)

		if @user.persisted?
			sign_in_and_redirect @user, event: :authentication
		else
			session[:omniauth_errors] = @user.errors.full_messages.to_sentence unless @user.save
		 	
		 	session[:omniauth_data] = data

		 redirect_to new_user_registration_url
		end
	end
end