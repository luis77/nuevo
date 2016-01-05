class Post < ActiveRecord::Base
  belongs_to :user
  has_many :attachments
  validates :titulo, presence:true, uniqueness: true
  include Picturable
end
