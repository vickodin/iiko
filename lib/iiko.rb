require "iiko/version"
require "iiko/web"
require "iiko/csv"
require "iiko/warehouse"

module Iiko
  def self.new(settings)
    Iiko::Web.new(settings)
  end

  # i = Iiko.new(url: 'https://xxx.xxx/resto', user: 'xxx', password: 'xxx')
  # goods_csv = i.goods
  # ttk_csv = i.ttk
  # goods_items = Iiko::CSV.new(goods_csv)
  # ttk_items = Iiko::CSV.new(ttk_csv)
  # goods_items.load
  # ttk_items.load
  # Iiko::Warehouse.ingredients(goods: goods_items, ttk: ttk_items)
end
