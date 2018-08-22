class CreateOffers < ActiveRecord::Migration[5.1]
  def change
    create_table :offers do |t|
      # METADATA
      t.belongs_to  :company
      t.integer     :off_id, limit: 8
      t.integer     :group_id, limit: 8
      t.boolean     :available
      t.string      :ctype

      # Relevant Offer info
      t.string      :url
      t.integer     :price
      t.integer     :base_price
      t.references   :currency, index: true
      # Descriptive info
      t.string      :picture
      t.string      :age
      t.string      :barcode
      t.string      :name
      t.string      :type_prefix
      t.string      :vendor
      t.string      :model
      t.string      :description
      t.string      :sales_notes

      # Delivery and warranty
      t.boolean     :store
      t.boolean     :pickup
      t.boolean     :delivery
      t.string      :ordering_time
      t.string      :manufacturer_warranty
      t.integer     :local_delivery_cost

      t.timestamps
    end
  end
end
