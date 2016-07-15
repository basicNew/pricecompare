class CreateProductMatches < ActiveRecord::Migration
  def change
    create_table :product_matches do |t|
      t.string :wallmart_product_id
      t.string :fravega_product_id

      t.timestamps null: false
    end
  end
end
