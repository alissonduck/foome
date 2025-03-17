class AddManagerForeignKeyToTeams < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :teams, :employees, column: :manager_id
    add_index :teams, :manager_id
  end
end
