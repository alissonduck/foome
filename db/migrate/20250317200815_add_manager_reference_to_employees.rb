class AddManagerReferenceToEmployees < ActiveRecord::Migration[8.0]
  def change
    add_column :employees, :manager_id, :bigint, null: true
    add_index :employees, :manager_id
    add_foreign_key :employees, :employees, column: :manager_id
  end
end
