class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable, omniauth_providers: [:facebook]

  has_many :posts
  has_many :friendships #amistades
 
  has_many :follows, through: :friendships, source: :user #follows va a ser las personas que nosotros seguimos. y through especificamos que vamos a tener muchos follows a traves de friendship. y source: :user es porque rails va tratar dentro de la tabla friendship un campo follow_id, ya que no hay ningun follow tenemos que indicarle de que atributo tiene q hacerlo, con el atributo source vamos a decirle que este es un user. y buscara usuario_id
 
  has_many :followers_friendships, class_name: "Friendship", foreign_key: "user_id" #como los followers es una relacion de muchos a muchos, necesitamos tambn una tabla intermediaria, pero no podemos usar la de friendship porque nos va a devolver otra vez los followers- para ello crearemos otro has many sin crear otra tabla. como no existe la tabla followers_friendships, y para no confundir al framework debemos especificar que la clase es friendship
 
  has_many :followers, through: :followers_friendships, source: :friend #van a ser las personas que nos siguen a nosotros

 def follow!(amigo_id) #en este metodo vamos a recibir el id de la persona a la que vamos a seguir. el signo de admiracion se usa como convencion cuando se va a crear o cambiar algo
    friendships.create!(friend_id: amigo_id) #el id del amigo al que vamos a seguir, es el que recibiremos como parametro
  end

  def can_follow?(amigo_id) #para evitar seguir dos veces a una misma persona y evitar seguirte a ti mismo
   not amigo_id == self.id or friendships.where(friend_id: amigo_id).size > 0 #validamos que el amigo_id no sea yo # o que ya exista esa relacion, lo cual indica que ya sigo a esa persona, por lo tanto busco en mi friend id sea el mismo del que me acaban de mandar como parametro, si eso me devuelve un conjunto con mas de un registro tampoco lo puedo seguir 
  end

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
