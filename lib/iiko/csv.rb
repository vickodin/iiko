require 'csv'

module Iiko
  class CSV

    attr_accessor :options, :headers
    attr_reader :path_to_csv, :raw

    alias_method :h, :headers

    def initialize(path_to_csv, options = {})
      @options = { col_sep: ';', quote_char: "\'" }.merge(options)
      @options[:headers] = false

      raise ArgumentError, "'path_to_csv' is required" unless path_to_csv
      @path_to_csv = path_to_csv
    end

    def load
      @raw = ::CSV.read(path_to_csv, options)
      prepare_headers
      self
    end

    def data
      raw[1..-1]
    end

    private

    def prepare_headers
      @headers = {}
      @raw[0].each_with_index { |field, index| @headers[field] = index }
    end

  end

end
