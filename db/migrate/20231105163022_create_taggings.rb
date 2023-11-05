class CreateTaggings < ActiveRecord::Migration[6.1]
  def change
    create_table :taggings do |t|
      t.references :post, null: false, foreign_key: { to_table: :posts } # post_idの外部キー制約を設定
      t.references :tag, null: false, foreign_key: { to_table: :tags } # tag_idの外部キー制約を設定

      t.timestamps
    end
  end
end
