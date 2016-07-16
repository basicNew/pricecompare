class FravegaScraper < Scraper

  protected

  def get_product_containers(list_page)
    list_page.search('.//li[.//*[contains(text(),"Comparar")]]//div[@class="image"]')
  end

  def get_product_url_from_container(container)
    container.at('a')['href']
  end

  def scrape_into(page, product_information, product)
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
  end

  def store
    'Fravega'
  end

  def list_url
    "#{base_url}/tv-y-video/tv/samsung"
  end

  def base_url
    'http://www.fravega.com'
  end

  def currency
    "ARS"
  end
end
