class AddFiledataToPaints < ActiveRecord::Migration
  def change
    add_column :paints, :filedata, :string
  end
end
