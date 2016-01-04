class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, omniauth_providers: [:facebook]

  has_many :posts
#colocando validates para validar, con el presence true hara que sea necesario ese campo a la hora de registrarse, en la longitud, se puede colocar el minimo y el maximo como aparece sombreado, o con el in q va de minimo 5 a maximo 20. si queremos q tenga solo un minimo sin importar el maximo, se deja solo el minimo y tambien nos permite notificar en el caso de que se escribio mucho o muy poco:
  #validates :username, presence: true, uniqueness: true, length: {in: 5..20, too_short: "Tiene que tener al menos 5 caracteres", too_long: "Máximo 20 caracteres"}#
#comente validates porque facebook no me da el username y por ende me crea conflictos a la hora de loguearme con facebook

  #metodo para buscar los usuarios
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(provider: auth.provider, uid: auth.uid).first
    # The User was found in our database
    return user if user
    # Check if the User is already registered without Facebook
    user = User.where(email: auth.info.email).first
    return user if user
    User.create(
    nombre: auth.extra.raw_info.name,
    provider: auth.provider, uid: auth.uid,
    email: auth.info.email,
    password: Devise.friendly_token[0,20])
  end

end
