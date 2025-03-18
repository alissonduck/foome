class RemoveComplementFromOffice < ActiveRecord::Migration[8.0]
  def change
    remove_column :offices, :complement
    remove_column :offices, :number
  end
end
