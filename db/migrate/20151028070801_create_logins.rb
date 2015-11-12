class CreateLogins < ActiveRecord::Migration
  def change
    create_table :logins do |t|
      t.string :userid, null: false
      t.string :mysign, null: false
      t.integer :kie, null: false, default: 1
      t.timestamps null: false
    end
  end
end
