class CreateCurrencies < ActiveRecord::Migration[5.1]
  def change
    create_table :currencies do |t|
      t.string :uid
      t.string :rate
      t.belongs_to :company

      t.timestamps
    end
  end
end
