class ChangeDatatimeNullPaints < ActiveRecord::Migration
  def change
    change_column_null :paints, :created_at, true
    change_column_null :paints, :updated_at, true
  end
end
