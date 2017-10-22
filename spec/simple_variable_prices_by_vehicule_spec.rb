require 'spec_helper'

describe 'Variable vehicule by distance' do
  it 'pick good vehicule' do
    request =  {
      'quote' => {
        'pickup_postcode' =>   'SW1A 1AA',
        'delivery_postcode' => 'EC2A 3LT',
        'vehicule' => 'bicycle'
      }
    }.to_json

    post '/quotes', request
    quote = JSON.parse(last_response.body)['quote']
    expect(quote['price']).to eql 746.9
    expect(quote['vehicule']).to eql "bicycle"
  end

  it 'pick next vehicule' do
    request =  {
      'quote' => {
        'pickup_postcode' =>   'SW1A 1AA',
        'delivery_postcode' => 'EC2A 3LT',
        'vehicule' => 'motorbike'
      }
    }.to_json

    post '/quotes', request
    quote = JSON.parse(last_response.body)['quote']

    expect(quote['price']).to eql 780.85
    expect(quote['vehicule']).to eql "motorbike"

  end

  it 'pick last vehicule' do
    request =  {
      'quote' => {
        'pickup_postcode' =>   'SW1A 1AA',
        'delivery_postcode' => 'EC2A 3LT',
        'vehicule' => 'large_van'
      }
    }.to_json

    post '/quotes', request
    quote = JSON.parse(last_response.body)['quote']

    expect(quote['price']).to eql 950.6
    expect(quote['vehicule']).to eql "large_van"

  end
end