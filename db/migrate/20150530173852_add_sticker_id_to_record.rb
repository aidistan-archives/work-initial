class AddStickerIdToRecord < ActiveRecord::Migration
  def change
    add_column :records, :sticker_id, :integer
  end
end
