class CreateTags < ActiveRecord::Migration[6.1]
  def change
    create_table :tags do |t|
      t.string :tag, null: false # タグ付けしないユーザーもいるためnullは許可すべき？

      t.timestamps
    end
    add_index :tags, :tag, unique:true # タグにユニーク制約を持たせ、同じタグは2回以上保存不可に設定
  end
end
