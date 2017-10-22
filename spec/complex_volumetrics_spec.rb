require 'spec_helper'

describe 'Variable vehicule by volumetrics' do
  it 'pick good vehicule' do
    request =  {
      'quote' => {
        'pickup_postcode' =>   'SW1A 1AA',
        'delivery_postcode' => 'EC2A 3LT',
        "products" => [
          {
            'weight'=> 2,
            'width'=> 3,
            'height'=> 4,
            'length'=> 2
          },
          {
            'weight'=> 2,
            'width'=> 24,
            'height'=> 4,
            'length'=> 2
          }
        ]
      }
    }.to_json

    post '/quotes', request
    quote = JSON.parse(last_response.body)['quote']
    expect(quote['price']).to eql 814.8
    expect(quote['vehicule']).to eql "parcel_car"
  end
end