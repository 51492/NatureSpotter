class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  
  # フォローしてる側のアソシエーション
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  
  # フォローされてる側のアソシエーション
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  
  # フォローしてるユーザーを取得
  has_many :followings, through: :active_relationships, source: :followed
  
  # フォロワーを取得
  has_many :followers, through: :passive_relationships, source: :follower


  # プロフィール画像関連 =========================================================
  has_one_attached :profile_image

  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/user_no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_fill: [width, height]).processed
  end
  # ==============================================================================

  # sessions_controllerの記述量を減らすためモデル内でクラスメソッドを定義 ========
  def self.guest
    find_or_create_by(email: "guest@example.com") do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "Guest"
      # user.confirmed_at = Time.now # メール確認機能用の記述
    end
  end
  # ==============================================================================
  
  
  # フォロー関連 =================================================================
    # 指定したユーザーをフォローする
  def follow(user)
    active_relationships.create(followed_id: user.id)
  end
  
  # 指定したユーザーのフォローを解除する
  def unfollow(user)
    active_relationships.find_by(followed_id: user.id).destroy
  end
  
  # 指定したユーザーをフォローしているかどうかを判定
  def following?(user)
    followings.include?(user)
  end
  # ==============================================================================
  
end


#以下参考

  # 簡単ログイン・ゲストログイン機能の実装方法（ポートフォリオ用）
    # https://qiita.com/take18k_tech/items/35f9b5883f5be4c6e104
    
  # 【Rails】フォロー・フォロワー機能
    # https://zenn.dev/ganmo3/articles/a3633e8f3209da