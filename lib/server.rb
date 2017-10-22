require 'sinatra'
require 'json'

module VehiculeManagement
  MIN_VEHICULE = 'bicycle'
  VEHICULES_PRICES = { 'bicycle' => 0.1 , 'motorbike' => 0.15 , 'parcel_car' => 0.2 , 'small_van' => 0.3 , 'large_van' => 0.4}
  VEHICULES_DISTANCES = { 'bicycle' => { 'dis' => 500 , 'next'=>'motorbike' } , 'motorbike' => { 'dis' => 750 , 'next'=>'parcel_car' },
   'parcel_car' => { 'dis' => 1000 , 'next'=>'small_van' } , 'small_van' => { 'dis' => 1500 , 'next'=>'large_van' } , 
   'large_van' => { 'dis' => -1 }}

   VEHICULES_VOLUMES = {  'bicycle' => { 'weight' => 3, 'width' => 25, 'height' => 10, 'length' => 30 , 'next'=>'motorbike'} ,
                            'motorbike' => { 'weight' => 6, 'width' => 25, 'height' => 25, 'length' => 35 , 'next'=>'parcel_car'},
                            'parcel_car' => { 'weight' => 50, 'width' => 100, 'height' => 75, 'length' => 100 , 'next'=>'small_van'},
                            'small_van' => { 'weight' => 400, 'width' => 133, 'height' => 133, 'length' => 133 , 'next'=>'large_van'},
                            'large_van' => { 'weight' => -1, 'width' => -1, 'height' => -1, 'length' => -1 }
      }

   def self.check_vehicule(vehicule, distance)
      while(VEHICULES_DISTANCES[vehicule]['dis'] != -1 && distance > VEHICULES_DISTANCES[vehicule]['dis'] )
        vehicule = VEHICULES_DISTANCES[vehicule]['next']
      end
      return vehicule
   end

   def self.find_vehicule_from_products(products)
      vehicule = MIN_VEHICULE
      prod = { 'weight' => 0 , 'width' => 0 , 'height' => 0 , 'length'=> 0}
      products.each do |product|
        prod['weight'] += product['weight']
        prod['width'] += product['width']
        prod['height'] += product['height']
        prod['length'] += product['length']
      end

      while( (VEHICULES_VOLUMES[vehicule]['weight'] != -1) && ( 
                (prod['weight'] > VEHICULES_VOLUMES[vehicule]['weight'] )||
                (prod['width'] > VEHICULES_VOLUMES[vehicule]['width'])||
                (prod['height'] > VEHICULES_VOLUMES[vehicule]['height'])||
                (prod['length'] > VEHICULES_VOLUMES[vehicule]['length'])))
          vehicule = VEHICULES_VOLUMES[vehicule]['next']
        end

      return vehicule
   end

end

module GameOfShutl
  class Server < Sinatra::Base
    post '/quotes' do
      quote = JSON.parse(request.body.read)
      price = ((quote['quote']['pickup_postcode'].to_i(36) - quote['quote']['delivery_postcode'].to_i(36)) / 1000).abs

      ####### Vehicule given
      if quote['quote'].key?('vehicule')
        vehicule = quote['quote']['vehicule']
        if quote['quote'].key?('distance')
          distance = quote['quote']['distance']
          vehicule = VehiculeManagement.check_vehicule(vehicule, distance)
        end
        price = price + price*VehiculeManagement::VEHICULES_PRICES[vehicule]
        {
          quote: {
            pickup_postcode: quote['quote']['pickup_postcode'],
            delivery_postcode: quote['quote']['delivery_postcode'],
            price: price,
            vehicule: vehicule
          }
        }.to_json
      ####### products given
      elsif quote['quote'].key?('products')
        products = quote['quote']['products']
        vehicule = VehiculeManagement.find_vehicule_from_products(products)
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