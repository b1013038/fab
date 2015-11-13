class RemoveCreatedAtFromLogins < ActiveRecord::Migration
  def change
    remove_column :logins, :created_at, :datetime
  end
end
