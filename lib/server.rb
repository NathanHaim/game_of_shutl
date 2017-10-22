require 'sinatra'
require 'json'

module VehiculeManagement
  VEHICULES_PRICES = { 'bicycle' => 0.1 , 'motorbike' => 0.15 , 'parcel_car' => 0.2 , 'small_van' => 0.3 , 'large_van' => 0.4}
end

module GameOfShutl
  class Server < Sinatra::Base
    post '/quotes' do
      quote = JSON.parse(request.body.read)
      price = ((quote['quote']['pickup_postcode'].to_i(36) - quote['quote']['delivery_postcode'].to_i(36)) / 1000).abs
      if quote['quote'].key?('vehicule')
        vehicule = quote['quote']['vehicule']
        price = price + price*VehiculeManagement::VEHICULES_PRICES[vehicule]
        {
          quote: {
            pickup_postcode: quote['quote']['pickup_postcode'],
            delivery_postcode: quote['quote']['delivery_postcode'],
            price: price,
            vehicule: vehicule
          }
        }.to_json
      else
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
end