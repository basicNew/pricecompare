require 'mechanize'
require 'open-uri'

class Scraper

  def initialize
    @agent = Mechanize.new
  end

  def run
    @agent.get(list_url)
    get_product_containers(@agent.page).each do |container|
      url = get_product_url_from_container(container)
      extra_information = get_product_information_from_container(container)
      fetch_product_from(ensure_full_url(url), extra_information)
    end
  end

  protected

  # Answer a collection of elements, each one containing
  # a product to fetch
  def get_product_containers(list_page); end

  # This is mandatory, as we need this to scrape the product data
  def get_product_url_from_container(container); end

  # This is an optional hook to get more information or
  # information that is more easily accessed in the list page
  def get_product_information_from_container(container); end

  # Given a url and possible more information, fetch the
  # page, create (and store) a scraped product.
  def fetch_product_from(url, extra_information)
    print "Fetching product from #{url}"
    begin
      @agent.get(url)
      product = ScrapedProduct.new(store: store, url: url)
      scrape_into(@agent.page, extra_information, product)
      product.save
      puts ' [OK]'
    rescue StandardError => e
      puts ' [FAIL]'
    end
  end

  # Fill the product details
  def scrape_into(page, product_information, product); end

  # The name of the store we are scraping
  def store; end

  # The url of the listing page
  def list_url; end

  # The base url of the site we are scraping
  def base_url; end

  # Currency this store uses
  def currency; end

  def price_from_string(price_string)
    if price_string.present?
      amount_string = price_string.delete("^0-9.,");
      Monetize.parse("#{currency} " + amount_string)
    end
  end

  def ensure_full_url(url)
    if URI.parse(url).host.blank?
      "#{base_url}#{url}"
    else
      url
    end
  end

  def get_text_if_available(page, xpath)
    value = page.search(xpath)[1]
    value.text.strip if value && value.text
  end

end
