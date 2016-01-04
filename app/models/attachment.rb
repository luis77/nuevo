class Attachment < ActiveRecord::Base
  belongs_to :post
  after_save :guardar_imagen

  PATH_ARCHIVOS = File.join Rails.root, "public", "archivos"

	  def archivo=(archivo)
	  	unless archivo.blank?
	  		@archivo = archivo
	  		self.nombre = archivo.original_filename	  		
	  		self.extension = archivo.original_filename.split(".").last.downcase
	  end
	end

	def path_archivo
		File.join PATH_ARCHIVOS, "#{self.id}.#{self.extension}"
	end

	def tiene_archivo?
		File.exist? path_archivo
	end

	private 
	def guardar_imagen
		if @archivo
			FileUtils.mkdir_p PATH_ARCHIVOS
			File.open(path_archivo,"wb") do |f|
				f.write(@archivo.read)
			end
			@archivo = nil
		end
	end
end