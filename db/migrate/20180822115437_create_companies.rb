class CreateCompanies < ActiveRecord::Migration[5.1]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :company_name
      t.string :url
      t.integer :local_delivery_cost
      t.belongs_to :source, index: true

      t.timestamps
    end
  end
end
