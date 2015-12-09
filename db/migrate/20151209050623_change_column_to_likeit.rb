class ChangeColumnToLikeit < ActiveRecord::Migration
  def change
    rename_column :likeit :num :id_id
  end
end
