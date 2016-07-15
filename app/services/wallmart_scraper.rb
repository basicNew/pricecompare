require 'mechanize'
require 'open-uri'

class WallmartScraper

  def initialize
    @agent = Mechanize.new
  end

  def run
    @agent.get(search_url)
    product_containers = @agent.page.search('//ul[@class="tile-list tile-list-grid"]//div[@class="js-tile tile-grid-unit"]')
    product_containers.each do |div|
      link = div.at('a[class="js-product-image"]')['href']
      image = div.at('img[class="product-image"]')
      image_url = image['data-default-image'] || image['src']
      fetch_product_from(link, image_url)
    end

  end

  private

  def fetch_product_from(url, image_url)
    product_url = "#{base_url}#{url}"
    print "Fetching product from #{product_url}"
    begin
      @agent.get(product_url)
      page = @agent.page
      product = ScrapedProduct.new(store: 'Wallmart', url: product_url)

      product.full_name = page.search('//h1[@itemprop="name"]//span').text.strip
      price_string = page.at('button:contains("Add to Registry")')['data-product-price'];
      product.price = price_from_string(price_string)

      product[:model] = get_text_if_available(page, '//tbody[@class="main-table"]//tr[.//td[contains(text(),"Model:")]]//td')
      product[:model] = product[:model].upcase if product[:model]
      product[:size] = get_text_if_available(page, '//tbody[@class="main-table"]//tr[.//td[contains(text(),"Screen Size:")]]//td')
      product[:normal_price] = price_from_string(get_text_if_available(page, '//span[contains(@class, "price-details-list-price")]'))
      product[:best_price] = product.price
      product[:image_url] = image_url

      product.save
      puts ' [OK]'
    rescue StandardError => e
      puts ' [FAIL]'
    end
  end

  def get_text_if_available(page, xpath)
    value = page.search(xpath)[1]
    value.text.strip if value && value.text
  end

  def search_url
    "#{base_url}/browse/electronics/all-tvs/3944_1060825_447913?cat_id=3944_1060825_447913&stores=-1&facet=brand:Samsung||condition:New"
  end

  def base_url
    'http://www.walmart.com'
  end

  def price_from_string(price_string)
    if price_string.present?
      amount_string = price_string.delete("^0-9.,");
      Monetize.parse("USD " + amount_string)
    end
  end

end


