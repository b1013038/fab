class RemoveKieToLogins < ActiveRecord::Migration
  def change
    remove_column :logins, :kie, :string
  end
end
