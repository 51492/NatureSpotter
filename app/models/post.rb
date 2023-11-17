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
    current_tags = self.tags.pluck(:tag) unless self.tags.nil? # self(クラス)のtagデータが存在していれば、タグを配列としてすべて取得
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
  def check_image
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/post_no_image.jpg')
      image.attach(io: File.open(file_path), filename: 'post_no_image.jpg', content_type: 'image/jpeg')
    end
      image
  end

  def get_image(width, height)
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/post_no_image.jpg')
      image.attach(io: File.open(file_path), filename: 'post_no_image.jpg', content_type: 'image/jpeg')
    end
      image.variant(resize_to_fill: [width, height]).processed
  end
  # ==============================================================================


  # 指定のユーザーが特定の投稿に対して既にいいねをしているか判断するメソッド =====
  def liked_by?(user)
    likes.exists?(user_id: user.id) # likesテーブルのuser_idカラムに引数user.idと一致するものはあるか？
  end
  # ==============================================================================

  # 検索関連 =====================================================================
  def self.looks(method, word)
    if method == "perfect_match"
      @post = Post.where("place LIKE?", "#{word}")
    elsif method == "forward_match"
      @post = Post.where("place LIKE?","#{word}%")
    elsif method == "backward_match"
      @post = Post.where("place LIKE?","%#{word}")
    elsif method == "partial_match"
      @post = Post.where("place LIKE?","%#{word}%")
    else
      @post = Post.all
    end
  end
  # ==============================================================================


  # geocoder =====================================================================
  geocoded_by :address, latitude: :post_latitude, longitude: :post_longitude
  # addressカラムを基準に緯度経度を算出し、対応するカラムに渡す
  after_validation :geocode, if: :address_changed? # address変更時に緯度経度も更新
  # ==============================================================================
end


#以下参考

  # Rails タグ付け機能
    # https://zenn.dev/goldsaya/articles/625bdf837c1c68

  #【Ruby on rails6】Google Map APIをアプリケーションに導入する
    # https://naskanoheya.com/catch-up/g-map/