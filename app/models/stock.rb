require 'httparty'

class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :users, through: :user_stocks

  validates :name, :ticker, presence: true

  def self.company_lookup(ticker_symbol)
    url = get_api_url('OVERVIEW', ticker_symbol)
    response = HTTParty.get(url)
    if response.code == 200
      response.parsed_response['Name']
    else
      nil
    end
  end

  def self.new_lookup(ticker_symbol)
    # MOCK
    # new(ticker: ticker_symbol, name: 'mock-name', last_price: 10)

    # REAL
    url = get_api_url('GLOBAL_QUOTE', ticker_symbol)
    response = HTTParty.get(url)
    if response.code == 200 &&
      response.parsed_response['Global Quote'].present? &&
      response.parsed_response['Global Quote']['05. price']
      last_price = response.parsed_response['Global Quote']['05. price']
      name = company_lookup(ticker_symbol)
      new(ticker: ticker_symbol, name: name, last_price: last_price)
    else
      nil
    end
  end

  def self.get_api_url(function, ticker_symbol)
    api_base_url = 'https://www.alphavantage.co'
    api_key = Rails.application.credentials.alphavantage_api_key
    "#{api_base_url}/query?function=#{function}&symbol=#{ticker_symbol}&apikey=#{api_key}"
  end
end
