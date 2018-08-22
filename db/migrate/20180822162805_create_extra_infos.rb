class CreateExtraInfos < ActiveRecord::Migration[5.1]
  def change
    create_table :extra_infos do |t|
      t.belongs_to  :offer
      t.string      :name
      t.string      :value

      t.timestamps
    end
  end
end
