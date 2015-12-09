class ChangeColumnNameToLikeit < ActiveRecord::Migration
  def change
    rename_column :likeits, :num, :id_id
  end
end
