class UserController < ApplicationController
	def show
		@user = User.find(params[:id]) #guarda el registro en la variable global id, toma el id de la url, y busca al usuario, almacenandolo en la variable de clase.
	end
end