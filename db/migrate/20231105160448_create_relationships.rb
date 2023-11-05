class CreateRelationships < ActiveRecord::Migration[6.1]
  def change
    create_table :relationships do |t|

      t.references :follower, null: false, foreign_key: { to_table: :users } # follower_idの外部キー制約を設定
      t.references :followed, null: false, foreign_key: { to_table: :users } # follewed_idの外部キー制約を設定
      t.timestamps
    end
  end
end
