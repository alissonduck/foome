class RemovePhoneFromCompany < ActiveRecord::Migration[8.0]
  def change
    remove_column :companies, :phone, :string
    remove_column :companies, :sector, :string
  end
end
