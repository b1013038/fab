class CreateLikeits < ActiveRecord::Migration
  def change
    create_table :likeits do |t|
      t.integer :num

      t.timestamps null: false
    end
  end
end
