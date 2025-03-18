class RemoveEmailFromCompanies < ActiveRecord::Migration[8.0]
  def change
    remove_column :companies, :email, :string
  end
end
