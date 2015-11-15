class AddKieToLogin < ActiveRecord::Migration
  def change
    add_column :logins, :kie, :text
  end
end
