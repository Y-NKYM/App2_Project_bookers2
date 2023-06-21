class ChangeDatatypeScoreOfBooks < ActiveRecord::Migration[6.1]
  def change
    change_column :books, :score, :integer
  end
end
