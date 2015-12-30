require 'test_helper'

class PostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "debe poder crear un post" do
  	post = Post.create(titulo: "Mi titulo", contenido: "Mi contenido")
  	assert post.save
  end
  #para poder editar un post debe de tener alguno creado, para eso existen los fixtures. creamos nuestro fixture en post.yml llamado primer_articulo
  test "debe actualizar un post" do
  	post = posts(:primer_articulo)
  	assert post.update(titulo: "Nuevo titulo", contenido: "Nuevo contendo :)")
  end
  #que encuentre un post por su id
  test "debe encontrar un post por su id" do
  	post_id = posts(:primer_articulo).id
  	assert_nothing_raised { Post.find(post_id) }  	
  end
  #esperamos que no haya una excepcion, es el inverso de encontrar algo
  test "debe borrar un post" do
	post = posts(:primer_articulo)
	post.destroy
	assert_raise(ActiveRecord::RecordNotFound) {Post.find(post.id)}
  end 
  #TDD este test va a fallar
  test "no debe crear un post sin titulo" do
  	post = Post.new
  	assert post.invalid?, "el post deberia ser invalido" 
  end 
  test "cada titulo tiene que ser unico" do
  	post = Post.new
  	post.titulo = posts(:primer_articulo).titulo
  	assert post.invalid? "Dos posts no pueden tener el mismo titulo"
  end
end
