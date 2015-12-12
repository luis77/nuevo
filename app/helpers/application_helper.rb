module ApplicationHelper
	def get_email_oauth
		if session[:omniauth_data] #validamos que exista una sesion con nuestro hash de datos, si existe, retornamos el correo que guardamos en ese hash y si no existe retonamos una cadena vacia
		   session[:omniauth_data][:email]
		else
			"" #retornamos una cadena vacia
		end
	end
end
