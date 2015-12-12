class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, omniauth_providers: [:facebook]   

  def self.find_or_create_by_omniauth(auth) #ayuda a saber si el usuario se a loggeado antes con omniauth, y va a reibir como parametro el hash data que se encuentra en omniauth_callbacks_controller
 	 user = User.where(provider: auth[:provider], uid: auth[:uid]).first #busca en la base de datos un usuario que ya se haya loggeado con esas mismas credenciales, o sea q ya exista un registro dentro de nuestra tabla de usuarios con el uid y el provider para identificar a los usuarios. el provider y el uid los sacamos del hash de omniauth_callbacks_controller

  unless user #aqui ya guardamos nuestra informacion en la base de datos
  	user = User.create(
  		nombre: auth[:nombre],
  		apellido: auth[:apellido],
  		username: auth[:username],
  		email: auth[:email],
  		uid: auth[:uid],
  		provider: auth[:provider],
  		password: Devise.friendly_token[0,20] #ya que devise no permite que nosotros agreguemos un registro con el password vacio, entonces generamos una cadena de caracteres aleatoreos ya que no podemos colocar una contraseña estandar porque eso explotaria la seguridad de nuestra aplicacion. friendly_token es un metodo de devise para generar contraseñas aleatorias
		)
	end
 end    
end
