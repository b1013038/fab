class AddKieToLogins < ActiveRecord::Migration
  def change
    add_column :logins, :kie, :string
  end
end
