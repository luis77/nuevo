class OmniauthCallbacksController <ApplicationController
	def facebook
		auth = request.env["omniauth.auth"]#el hash con la info del usuario se encuentra en omniauth.auth q contiene la informacion para autenticar al usuario
		#raise auth.to_yaml #explota una excepcion de ruby a proposito para poder inspeccionar el archivo o hash que nos envio omniauth de regreso
		data = {
			nombre: auth.info.first_name, #infornacion que requeriremos del usuario
			apellido: auth.info.last_name,
			username: auth.info.nickname,
			email: auth.info.email,
			provider: auth.provider, #proveedor
			uid: auth.uid #identificador
		}

		@user = User.find_or_create_by_omniauth(data) #hacemos uso del metodo que creamos en el modelo de usuario, pasandole como parametro el hash que lleva por nombre data

		if @user.persisted? #el metodo persisted? del active records de rails devuelve verdadero si el registro ya esta guardado dentro de nuestra base de datos. si en este caso la variable usuarios contiene la informacion completa pero no pudo guardarse por alguna razon, persisted devolvera falso.
			sign_in_and_redirect @user, event: :authentication #en caso de que el usuario si se pudo guardar, lo que haremos sera loggearlo y redireccionarlo
		else #en caso de que devuelva faso, por algun error como que ese email ya exista en nuestra base de datos
			session[:omniauth_errors] = @user.errors.full_messages.to_sentence unless @user.save #notificamos al usuario los errores que impidieron que se guardara y .to_sentence convierte ese mensaje en mensaje natural, en vez de codigo
		 	
		 	session[:omniauth_data] = data #guardamos el hash con la informacion

		 redirect_to new_user_registration_url #si no pudimos registrar al usuario, lo enviamos a la ventana de reistro
		end
	end
end