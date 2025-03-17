class CreateOffices < ActiveRecord::Migration[8.0]
  def change
    create_table :offices do |t|
      t.references :company, null: false, foreign_key: true
      t.references :city, null: false, foreign_key: true
      t.string :name
      t.string :address
      t.string :zip_code
      t.string :number
      t.string :complement
      t.string :neighborhood
      t.jsonb :google_infos
      t.boolean :active

      t.timestamps
    end
  end
end
