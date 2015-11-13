class AddPasswordSaltToLogins < ActiveRecord::Migration
  def change
    add_column :logins, :password_salt, :string
  end
end
