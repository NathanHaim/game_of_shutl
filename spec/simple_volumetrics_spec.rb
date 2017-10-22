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
          }
        ]
      }
    }.to_json

    post '/quotes', request
    quote = JSON.parse(last_response.body)['quote']
    expect(quote['price']).to eql 746.9
    expect(quote['vehicule']).to eql "bicycle"
  end


  it 'pick second vehicule' do
    request =  {
      'quote' => {
        'pickup_postcode' =>   'SW1A 1AA',
        'delivery_postcode' => 'EC2A 3LT',
        "products" => [
          {
            'weight'=> 2,
            'width'=> 3,
            'height'=> 4,
            'length'=> 32
          }
        ]
      }
    }.to_json

    post '/quotes', request
    quote = JSON.parse(last_response.body)['quote']
    expect(quote['price']).to eql 780.85
    expect(quote['vehicule']).to eql "motorbike"
  end

  it 'pick one before last vehicule' do
    request =  {
      'quote' => {
        'pickup_postcode' =>   'SW1A 1AA',
        'delivery_postcode' => 'EC2A 3LT',
        "products" => [
          {
            'weight'=> 399,
            'width'=> 3,
            'height'=> 4,
            'length'=> 32
          }
        ]
      }
    }.to_json

    post '/quotes', request
    quote = JSON.parse(last_response.body)['quote']
    expect(quote['price']).to eql 882.7
    expect(quote['vehicule']).to eql "small_van"
  end

  it 'pick last vehicule' do
    request =  {
      'quote' => {
        'pickup_postcode' =>   'SW1A 1AA',
        'delivery_postcode' => 'EC2A 3LT',
        "products" => [
          {
            'weight'=> 402,
            'width'=> 3,
            'height'=> 4,
            'length'=> 32
          }
        ]
      }
    }.to_json

    post '/quotes', request
    quote = JSON.parse(last_response.body)['quote']
    expect(quote['price']).to eql 950.6
    expect(quote['vehicule']).to eql "large_van"
  end
end

