class CreateOfferCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :offer_categories do |t|
      t.belongs_to :offer, index: true
      t.belongs_to :category, index: true

      t.timestamps
    end
  end
end
