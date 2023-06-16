class RenameRequestColumnToRelationships < ActiveRecord::Migration[6.1]
  def change
    rename_column :relationships, :follower, :follower_id
    rename_column :relationships, :followed, :followed_id
  end
end
