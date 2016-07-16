class WallmartScraper < Scraper

  protected

  def get_product_containers(list_page)
    list_page.search('//ul[@class="tile-list tile-list-grid"]//div[@class="js-tile tile-grid-unit"]')
  end

  def get_product_url_from_container(container)
    container.at('a[class="js-product-image"]')['href']
  end

  def get_product_information_from_container(container)
    image = container.at('img[class="product-image"]')
    return {
      image_url: image['data-default-image'] || image['src']
    }
  end

  def scrape_into(page, product_information, product)
    product.full_name = page.search('//h1[@itemprop="name"]//span').text.strip
    price_string = page.at('button:contains("Add to Registry")')['data-product-price'];
    product.price = price_from_string(price_string)

    product[:model] = get_text_if_available(page, '//tbody[@class="main-table"]//tr[.//td[contains(text(),"Model:")]]//td')
    product[:model] = product[:model].upcase if product[:model]
    product[:size] = get_text_if_available(page, '//tbody[@class="main-table"]//tr[.//td[contains(text(),"Screen Size:")]]//td')
    product[:normal_price] = price_from_string(get_text_if_available(page, '//span[contains(@class, "price-details-list-price")]'))
    product[:best_price] = product.price
    product[:image_url] = product_information[:image_url]
  end

  def store
    'Wallmart'
  end

  def list_url
    "#{base_url}/browse/electronics/all-tvs/3944_1060825_447913?cat_id=3944_1060825_447913&stores=-1&facet=brand:Samsung||condition:New"
  end

  def base_url
    'http://www.walmart.com'
  end

  def currency
    "USD"
  end
end
