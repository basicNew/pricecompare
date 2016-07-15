class ProductMatchmaker

  def find_matches
    wallmart_products = valid_scraped_products_from('Wallmart')
    fravega_products = valid_scraped_products_from('Fravega')
    # Admittedly not a performant algorithm and definitely
    # not something you want to do in production with real
    # data, but works for a small example.
    fravega_products.each do |fravega_product|
      fravega_model = fravega_product[:model]
      wallmart_products.each do |wallmart_product|
        wallmart_model = wallmart_product[:model]
        if (wallmart_model.include?(fravega_model) || fravega_model.include?(wallmart_model))
          match = ProductMatch.new
          match.wallmart_product = wallmart_product
          match.fravega_product = fravega_product
          match.save!
        end
      end
    end
  end

  private

  def valid_scraped_products_from(store)
    ScrapedProduct.where(:model.nin => ["", nil], store: store)
  end

end
