module Picturable
	extend ActiveSupport::Concern
	
	included do #se debe de hacer el included en el concern
		after_save :guardar_imagen #llama al metodo de abajo
	end

	if self.respond_to?(:nombre)
  		PATH_ARCHIVOS = File.join Rails.root, "public", "archivos", "attachments" #para identificar sobre que ruta esta nuestro proyecto rails podemos hacer un rails.root, y con file.join concatenamos eso con los siguientes deirectorios, q es public y archivos, o sea estaria dentro de la_carpeta_del_proyecto/public/archivos
	else
  		PATH_ARCHIVOS = File.join Rails.root, "public", "archivos", "posts" #para identificar sobre que ruta esta nuestro proyecto rails podemos hacer un rails.root, y con file.join concatenamos eso con los siguientes deirectorios, q es public y archivos, o sea estaria dentro de la_carpeta_del_proyecto/public/archivos
  	end
  	
	  def archivo=(archivo) #creamos un metodo archivo
	  	unless archivo.blank? #validamos que el archivo no venga en blanco
	  		@archivo = archivo #lo guardamos en una variable de clase
	  		#en el concern, como el metodo post no tiene un atributo nombre entonces nos dara un error
	  		if self.respond_to?(:nombre)
	  			self.nombre = archivo.original_filename #guarda el nombre original del archivo  		
	  		end
	  		self.extension = archivo.original_filename.split(".").last.downcase #guarda la extension del archivo(formato). lo guardamos partiendo la cadena del nombre basado en el punto . , tomando la ultima parte de esa cadena y pasandola a miniscula
	  end
	end

	def path_archivo
		File.join PATH_ARCHIVOS, "#{self.id}.#{self.extension}"   #devuelve la ruta especifica de ese archivo. coloca el nombre y la extension cuando cuarda la imagen. ej: para el attachment id 1 la imagen se llamara 1 y la extension
	end

	def tiene_archivo?
		File.exist? path_archivo #verificamos q el archivo exista
	end

	private 
	def guardar_imagen
		if @archivo #verificamos que exista la variable de clase archivo, o sea que el usuario haya mandado un archivo a traves del formulario
			FileUtils.mkdir_p PATH_ARCHIVOS #creamos un directorio, la ruta estara en path archivos, creamos la variable path_archivos mas arriba
			File.open(path_archivo,"wb") do |f| #abrimos el archivo, pathimagen es para conocer la ruta del directorio, lo abriremos con permisos de escritura
				f.write(@archivo.read)
			end
			@archivo = nil
		end
	end
end