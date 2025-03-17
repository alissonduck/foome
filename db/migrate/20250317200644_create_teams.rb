class CreateTeams < ActiveRecord::Migration[8.0]
  def change
    create_table :teams do |t|
      t.references :company, null: false, foreign_key: true
      t.string :name
      t.bigint :manager_id, null: true
      t.boolean :active

      t.timestamps
    end
  end
end
