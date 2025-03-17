class CreateCities < ActiveRecord::Migration[8.0]
  def change
    create_table :cities, id: :integer do |t|
      t.string :name, null: false
      t.references :state, null: false, foreign_key: true, type: :integer

      t.timestamps
    end

    add_index :cities, [ :state_id, :name ]
  end
end
