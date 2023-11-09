class Post < ApplicationRecord

  has_one_attached :image
  belongs_to :user

  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  # タグ機能のアソシエーション
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  # タグ保存のためのメソッド =====================================================
  def save_tags(tags)
    current_tags = self.tags.pluck(:tag) unless self.tags.nil? # self(クラス)のtagデータが存在していれば、タグの名前を配列としてすべて取得
    old_tags = current_tags - tags # 既存のタグから送られてきたタグを除いたタグ
    new_tags = tags - current_tags # 送られてきたタグから既存のタグを除いたタグ

    # 古いタグを削除
    old_tags.each do |old_tag|
      self.workout_tags.delete WorkoutTag.find_by(tag:old_tag)
    end

    # 新しいタグを保存
    new_tags.each do |new_tag|
      tag = Tag.find_or_create_by(tag:new_tag)
      self.tags << tag
    end
  end
  # ==============================================================================
  

  # 投稿時画像が無い場合no_image.jpgを表示するメソッド ===========================
  def get_image(width, height)
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/post_no_image.jpg')
      image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
      image.variant(resize_to_fill: [width, height]).processed
  end
  # ==============================================================================
  
  
  # 指定のユーザーが特定の投稿に対して既にいいねをしているか判断するメソッド =====
  def liked_by?(user)
    likes.exists?(user_id: user.id) # likesテーブルのuser_idカラムに引数user.idと一致するものはあるか？
  end
  # ==============================================================================

end


#以下参考

  # Rails タグ付け機能
    # https://zenn.dev/goldsaya/articles/625bdf837c1c68