class CreateOfferCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :categories_offers do |t|
      t.belongs_to :category, index: true
      t.belongs_to :offer, index: true

      t.timestamps
    end
  end
end
