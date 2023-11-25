class CreateTaggings < ActiveRecord::Migration[6.1]
  def change
    create_table :taggings do |t|
      t.references :post, null: false,type: :bigint, foreign_key: { to_table: :posts } # post_idの外部キー制約を設定
      t.references :tag, null: false,type: :bigint, foreign_key: { to_table: :tags } # tag_idの外部キー制約を設定

      t.timestamps
    end
    
    add_index :taggings, [:post_id,:tag_id],unique: true # タグにユニーク制約を持たせ、同じタグは2回以上保存不可に設定
  end
end
