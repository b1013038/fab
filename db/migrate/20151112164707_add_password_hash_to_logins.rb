class AddPasswordHashToLogins < ActiveRecord::Migration
  def change
    add_column :logins, :password_hash, :string
  end
end
