class AddTimestampsToLogins < ActiveRecord::Migration
  def change
    add_column :logins, :created_at, :datetime
    add_column :logins, :updated_at, :datetime
  end
end
