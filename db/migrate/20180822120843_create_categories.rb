class CreateCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :categories do |t|
      t.integer :cat_id
      t.references :parent, index: true
      t.string :name
      t.belongs_to :company

      t.timestamps
    end
  end
end
