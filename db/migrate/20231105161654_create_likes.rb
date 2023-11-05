class CreateLikes < ActiveRecord::Migration[6.1]
  def change
    create_table :likes do |t|
      t.references :user, null: false, foreign_key: { to_table: :users } # user_idの外部キー制約を設定
      t.references :post, null: false, foreign_key: { to_table: :posts } # post_idの外部キー制約を設定

      t.timestamps
    end
  end
end
