class CheckOut
  def initialize(rules)
    @rules = rules
    @goods = []
  end

  def scan(good)
    goods << good unless good.nil?
  end

  def total
    rules.map { |r| r.call(goods) }.reduce(0, &:+)
  end

  private

  attr_reader :rules, :goods
end

class ModPrice
  def initialize(sku:, regular_price:, quantity: 1, special_price: regular_price)
    @sku = sku
    @regular_price = regular_price
    @quantity = quantity
    @special_price = special_price
  end

  def call(goods)
    goods
      .count { |g| g == sku }
      .divmod(quantity)
      .zip([special_price, regular_price])
      .map { |(q, p)| q * p }
      .reduce(&:+)
  end

  private

  attr_reader :sku, :quantity, :regular_price, :special_price
end
