class CreatePaints < ActiveRecord::Migration
  def change
    create_table :paints do |t|
      t.string :userid, null: false
      t.integer :category, null: false
      t.string :title, null: false
      t.binary :filedata, null: false

      t.timestamps null: false
    end
  end
end
