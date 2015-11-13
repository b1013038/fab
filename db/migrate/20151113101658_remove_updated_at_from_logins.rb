class RemoveUpdatedAtFromLogins < ActiveRecord::Migration
  def change
    remove_column :logins, :updated_at, :datetime
  end
end
