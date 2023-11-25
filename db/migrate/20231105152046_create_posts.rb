class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: { to_table: :users } # user_idの外部キー制約を設定
      t.text :caption
      t.string :place, null: false
      t.string :address, null: false
      t.float :post_latitude, :limit=>53
      t.float :post_longitude, :limit=>53

      t.timestamps
    end
  end
end
