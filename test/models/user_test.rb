require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "debe crear un usuario" do
  	u = User.new(username: "luis", email:"luis@gmail.com", password: "12345678")
  	assert u.save
  end
end
