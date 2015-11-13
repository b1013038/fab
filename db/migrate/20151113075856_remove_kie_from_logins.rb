class RemoveKieFromLogins < ActiveRecord::Migration
  def change
    remove_column :logins, :kie, :int
  end
end
