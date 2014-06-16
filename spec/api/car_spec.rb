require 'rails_helper'

describe 'Car API' do

  before do
    @ford = create_make(name: "Ford")
    @bronco = create_car(color: "red", doors: 4, purchased_on: "1973-10-04", make_id: @ford.id)
  end

  describe 'Get /cars response' do
    it 'returns a list of cars' do
      mustang = create_car(color: "blue", doors: 2, purchased_on: "2012-01-24", make_id: @ford.id)

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
                  "href" => "/cars/#{@bronco.id}"
                },
                "make" => {
                  "href" => "/makes/#{@ford.id}"
                }
              },
              "id" => @bronco.id,
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
                  "href" => "/makes/#{@ford.id}"
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

  describe 'get /cars/:id' do
    it 'returns details about a car' do
      get "/cars/#{@bronco.id}", {}, {'Accept' => 'application/json'}

      expected = {
        "_links" => {
          "self" => {
            "href" => "/cars/#{@bronco.id}"
          },
          "make" => {
            "href" => "/makes/#{@ford.id}"
          }
        },
        "id" => @bronco.id,
        "color" => "red",
        "doors" => 4,
        "purchased_on" => "1973-10-04"
      }
      expect(response.code.to_i).to eq 200
      expect(JSON.parse(response.body)).to eq expected
    end

    it 'will render a 404 if the car does not exist' do
      get "/cars/1", {}, {'Accept' => 'application/json'}

      expect(response.code.to_i).to eq 404
      expect(JSON.parse(response.body)).to eq({})
    end
  end

  describe 'post /cars' do
    it 'allows a user to create a car' do
      body = {
        "make_id" => @ford.id,
        "color" => "red",
        "doors" => 4,
        "purchased_on" => "1973-10-04"
      }.to_json

      expect{post '/cars', body, {'Accept' => 'application/json'}}.to change{Car.count}.by 1

      car = Car.last

      expected = {
        "_links" => {
          "self" => {
            "href" => "/cars/#{car.id}"
          },
          "make" => {
            "href" => "/makes/#{@ford.id}"
          }
        },
        "id" => car.id,
        "color" => "red",
        "doors" => 4,
        "purchased_on" => "1973-10-04"
      }
      expect(response.code.to_i).to eq 201
      expect(JSON.parse(response.body)).to eq expected

    end
  end
end
