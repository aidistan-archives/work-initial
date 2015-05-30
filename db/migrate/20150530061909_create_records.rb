class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.references :user, index: true, foreign_key: true
      t.references :category, index: true, foreign_key: true
      t.text :text
      t.string :image
      t.string :attr_val1
      t.string :attr_val2

      t.timestamps null: false
    end
    add_index :records, [:user_id, :created_at]
  end
end
