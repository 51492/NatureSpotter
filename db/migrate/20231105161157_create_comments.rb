class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.references :user, null: false, foreign_key: { to_table: :users } # user_idの外部キー制約を設定
      t.references :post, null: false, foreign_key: { to_table: :posts } # post_idの外部キー制約を設定
      t.text :comment

      t.timestamps
    end
  end
end
