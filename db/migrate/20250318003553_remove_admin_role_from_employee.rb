class RemoveAdminRoleFromEmployee < ActiveRecord::Migration[8.0]
  def change
    remove_column :employees, :role_name, :string
  end
end
