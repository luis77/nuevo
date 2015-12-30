class Post < ActiveRecord::Base
  belongs_to :usuario
  validates :titulo, presence:true, uniqueness: true
end
