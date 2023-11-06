class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_many :posts, dependent: :destroy

  # sessions_controllerの記述量を減らすためモデル内でクラスメソッドを定義 ========
  def self.guest
    find_or_create_by(email: "guest@example.com") do |user|
      user.password = SecureRandom.urlsafe_base64
      # user.confirmed_at = Time.now # メール確認機能用の記述
    end
  end
  # ==============================================================================

end


#以下参考

  # 簡単ログイン・ゲストログイン機能の実装方法（ポートフォリオ用）
    # https://qiita.com/take18k_tech/items/35f9b5883f5be4c6e104