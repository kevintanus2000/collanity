class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :size
      t.string :brands
      t.text :categories
      t.text :ingredients
      t.string :code
      t.text :image

      t.timestamps
    end
  end
end
