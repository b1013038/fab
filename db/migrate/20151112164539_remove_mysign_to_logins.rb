class RemoveMysignToLogins < ActiveRecord::Migration
  def change
    remove_column :logins, :mysign, :string
  end
end
