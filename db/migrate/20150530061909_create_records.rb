class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.references :user, index: true, foreign_key: true
      t.references :category, index: true, foreign_key: true
      t.string :attr_val
      t.text :text
      t.string :image

      t.timestamps null: false
    end
    add_index :records, [:user_id, :created_at]
  end
end
