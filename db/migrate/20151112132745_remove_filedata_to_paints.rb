class RemoveFiledataToPaints < ActiveRecord::Migration
  def change
    remove_column :paints, :filedata, :string
  end
end
