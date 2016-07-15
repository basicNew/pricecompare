class AddUsdToArsToProductMatches < ActiveRecord::Migration
  def change
    add_column :product_matches, :usd_to_ars, :float
  end
end
