class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.references :user, null: false, foreign_key: { to_table: :users } # user_idの外部キー制約を設定
      t.text :caption
      t.string :place
      t.string :address
      t.float :post_latitude
      t.float :post_longitude

      t.timestamps
    end
  end
end
