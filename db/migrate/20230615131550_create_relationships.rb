class CreateRelationships < ActiveRecord::Migration[6.1]
  def change
    create_table :relationships do |t|
      t.integer :follower
      t.integer :followed

      t.timestamps
    end
  end
end
