class RemoveAddressFromOffice < ActiveRecord::Migration[8.0]
  def change
    remove_column :offices, :address
  end
end
