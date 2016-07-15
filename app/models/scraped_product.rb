class ScrapedProduct
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic
  include Mongoid::Timestamps::Created

  # We have some mandatory fields. The rest of
  # the object is schemaless
  field :store, type: String
  field :url, type: String
  field :full_name, type: String
  field :price, type: Money
  field :currency, type: String

  def price_in(currency)
    self.price.exchange_to(currency)
  end

end
