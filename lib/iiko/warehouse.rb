require 'csv'

module Iiko
  class Warehouse

    def self.ingredients(data = nil)
      validate_arguments(data)
      goods = data[:goods]
      goods.headers['ingredients'] = goods.headers.length
      gh = goods.headers

      goods_map = {}
      goods.data.each do |item|
        goods_map[item[gh['NUM']]] = item
      end


      ttk = data[:ttk]
      th = ttk.headers

      ttk.data.each do |ingredient|
        goods_map[ingredient[th['PRODUCT_CODE']]][gh['ingredients']] ||= []
        goods_map[ingredient[th['PRODUCT_CODE']]][gh['ingredients']].push(ingredient)
      end
    end

    private

    def self.validate_arguments(data)
      [:goods, :ttk].each do |arg|
        raise ArgumentError, "#{arg} is required" unless data[arg]
        # TODO: Check arg class
      end
    end
  end

end
