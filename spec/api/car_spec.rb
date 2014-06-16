require 'rails_helper'

describe 'Car API' do
  describe 'Get /cars response' do
    it 'returns a list of cars' do
      ford = create_make(name: "Ford")
      bronco = create_car(color: "red", doors: 4, purchased_on: "1973-10-04", make_id: ford.id)
      mustang = create_car(color: "blue", doors: 2, purchased_on: "2012-01-24", make_id: ford.id)


      get '/cars', {}, {'Accept' => 'application/json'}

      expected = {
        "_links" => {
          "self" => {
            "href" => "/cars"
          }
        },
        "_embedded" => {
          "cars" => [
            {
              "_links" => {
                "self" => {
                  "href" => "/cars/#{bronco.id}"
                },
                "make" => {
                  "href" => "/makes/#{ford.id}"
                }
              },
              "id" => bronco.id,
              "color" => "red",
              "doors" => 4,
              "purchased_on" => "1973-10-04"
            },
            {
              "_links" => {
                "self" => {
                  "href" => "/cars/#{mustang.id}"
                },
                "make" => {
                  "href" => "/makes/#{ford.id}"
                }
              },
              "id" => mustang.id,
              "color" => "blue",
              "doors" => 2,
              "purchased_on" => "2012-01-24"
            }
          ]
        }
      }
      expect(response.code.to_i).to eq 200
      expect(JSON.parse(response.body)).to eq expected
    end
  end
end
