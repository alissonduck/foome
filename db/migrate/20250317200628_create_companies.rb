class CreateCompanies < ActiveRecord::Migration[8.0]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :email
      t.string :cnpj
      t.string :phone
      t.string :sector
      t.string :employee_count
      t.string :work_regime
      t.integer :max_users
      t.boolean :active
      t.boolean :onboarding_completed
      t.boolean :terms_accepted

      t.timestamps
    end
  end
end
