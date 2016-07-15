class ProductMatch < ActiveRecord::Base

  after_initialize :set_usd_to_ars

  # Quick way of getting a relationship with
  # Mongo docs. MongoMysqlRelations is not
  # working out of the box.

  def wallmart_product
    ScrapedProduct.where(:_id => wallmart_product_id).first
  end

  def wallmart_product=(product)
    update_attributes(:wallmart_product_id => product.id.to_s)
  end

  def fravega_product
    ScrapedProduct.where(:_id => fravega_product_id).first
  end

  def fravega_product=(product)
    update_attributes(:fravega_product_id => product.id.to_s)
  end

  def fravega_to_wallmart_ratio
    fravega_product.price_in("USD") / wallmart_product.price
  end

  def should_flag?
    !fravega_to_wallmart_ratio.between?(0.8, 1.2)
  end


  private

  def set_usd_to_ars
    self.usd_to_ars = Money.default_bank.get_rate("USD", "ARS")
  end
end
