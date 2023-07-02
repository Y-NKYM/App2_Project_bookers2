class AddColumnsToEntry < ActiveRecord::Migration[6.1]
  def change
    add_column :entries, :user_id, :integer
    add_column :entries, :room_id, :integer
  end
end
