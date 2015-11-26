class ChangePasswordNullLogins < ActiveRecord::Migration
  def change
    change_column_null :logins, :password_salt, false
    change_column_null :logins, :password_hash, false
  end
end
