require 'sinatra'
require 'json'

module GameOfShutl
  class Server < Sinatra::Base
    post '/quotes' do
      quote = JSON.parse(request.body.read)
      price = ((quote['quote']['pickup_postcode'].to_i(36) - quote['quote']['delivery_postcode'].to_i(36)) / 1000).abs
      {
        quote: {
          pickup_postcode: quote['quote']['pickup_postcode'],
          delivery_postcode: quote['quote']['delivery_postcode'],
          price: price
        }
      }.to_json
    end
  end
end