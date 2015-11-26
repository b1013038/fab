class AddUseridIndexToLogins < ActiveRecord::Migration
  def change
    add_index :logins, :userid, unique: true
  end
end
