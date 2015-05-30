class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.string :attr_name1
      t.string :attr_name2
      t.string :placeholder1
      t.string :placeholder2

      t.timestamps null: false
    end
  end
end
