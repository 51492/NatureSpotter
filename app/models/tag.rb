class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :posts, through: :taggings
  
  def self.search(search)
    if search != '#'
      tag = Tag.where(tag: search)
      tag[0].posts
    else
      post.all
    end
  end

  validates :tag, presence:true, length:{maximum:50}
end
