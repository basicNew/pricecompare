require 'mechanize'
require 'open-uri'

class FravegaScraper

  def initialize
    @agent = Mechanize.new
  end

  def run
    @agent.get(base_url)
    product_links = @agent.page.search('.//li[.//*[contains(text(),"Comparar")]]//div[@class="image"]//a')
    product_links.each do |anchor|
      fetch_product_from(anchor['href'])
    end
  end

  private

  def fetch_product_from(url)
    print "Fetching product from #{url}"
    begin
      @agent.get(url)
      page = @agent.page
      product = ScrapedProduct.new(store: 'Fravega', url: url)
      product.full_name = page.at('meta[name="Abstract"]')['content']
      product[:model] = page.at('td[class="value-field Modelo"]').try(:text)
      if (product[:model])
        product[:model] = product[:model].match(/(.*)\"(\s*)([^\s]*)/)[3].upcase
      end
      product[:size] = page.at('td[class="value-field Pulgadas"]').try(:text)
      product[:normal_price] = price_from_string(page.css('.skuListPrice').try(:text))
      product[:best_price] = price_from_string(page.css('.skuBestPrice').try(:text))
      product[:image_url] = page.at('img[id="image-main"]')['src']
      product.price = product.best_price || product.normal_price
      product.save
      puts ' [OK]'
    rescue StandardError => e
      puts ' [FAIL]'
    end
  end

  def base_url
    'http://www.fravega.com/tv-y-video/tv/samsung'
  end

  def price_from_string(price_string)
    if price_string.present?
      amount_string = price_string.delete("^0-9.,");
      Monetize.parse("ARS " + amount_string)
    end
  end

end


