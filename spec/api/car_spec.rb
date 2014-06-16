require 'rails_helper'

describe 'Car API' do

  before do
    @ford = create_make(name: "Ford")
  end

  describe 'Get /cars response' do
    it 'returns a list of cars with version 1' do
      bronco = create_car(color: "red", doors: 4, purchased_on: "1973-10-04", make_id: @ford.id)
      mustang = create_car(color: "blue", doors: 2, purchased_on: "2012-01-24", make_id: @ford.id)

      get '/cars', {}, {'Accept' => 'application/json', 'X-Api-Version' => 'v1'}

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
                  "href" => "/makes/#{@ford.id}"
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

    it 'returns a list of cars with v2' do
      bronco = create_car(color: "red", purchased_on: "1973-10-04", make_id: @ford.id)
      mustang = create_car(color: "blue", purchased_on: "2012-01-24", make_id: @ford.id)

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
                  "href" => "/makes/#{@ford.id}"
                }
              },
              "id" => bronco.id,
              "color" => "red",
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
    it 'returns details about a car with the v1 api' do
      bronco = create_car(color: "red", doors: 4, purchased_on: "1973-10-04", make_id: @ford.id)
      get "/cars/#{bronco.id}", {}, {'Accept' => 'application/json', 'X-Api-Version' => 'v1'}

      expected = {
        "_links" => {
          "self" => {
            "href" => "/cars/#{bronco.id}"
          },
          "make" => {
            "href" => "/makes/#{@ford.id}"
          }
        },
        "id" => bronco.id,
        "color" => "red",
        "doors" => 4,
        "purchased_on" => "1973-10-04"
      }
      expect(response.code.to_i).to eq 200
      expect(JSON.parse(response.body)).to eq expected
    end

    it 'returns details about a car with the v2 api' do
      bronco = create_car(color: "red", purchased_on: "1973-10-04", make_id: @ford.id)
      get "/cars/#{bronco.id}", {}, {'Accept' => 'application/json'}

      expected = {
        "_links" => {
          "self" => {
            "href" => "/cars/#{bronco.id}"
          },
          "make" => {
            "href" => "/makes/#{@ford.id}"
          }
        },
        "id" => bronco.id,
        "color" => "red",
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
    it 'allows a user to create a car with the v1 api' do
      body = {
        "make_id" => @ford.id,
        "color" => "red",
        "doors" => 4,
        "purchased_on" => "1973-10-04"
      }.to_json

      user = create_user

      expect { post '/cars', body, {'Accept' => 'application/json', 'Authorization' => user.api_authentication_token, 'X-Api-Version' => 'v1'} }.to change { Car.count }.by 1

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

    it 'allows a user to create a car with the v2 api' do
      body = {
        "make_id" => @ford.id,
        "color" => "red",
        "purchased_on" => "1973-10-04"
      }.to_json

      user = create_user

      expect { post '/cars', body, {'Accept' => 'application/json', 'Authorization' => user.api_authentication_token} }.to change { Car.count }.by 1

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
        "purchased_on" => "1973-10-04"
      }
      expect(response.code.to_i).to eq 201
      expect(JSON.parse(response.body)).to eq expected
    end

    it 'does not allow a car with doors if it is posted using the v2 api' do
      body = {
        "make_id" => @ford.id,
        "color" => "red",
        "doors" => 4,
        "purchased_on" => "1973-10-04"
      }.to_json

      user = create_user

      expect { post '/cars', body, {'Accept' => 'application/json', 'Authorization' => user.api_authentication_token} }.to change { Car.count }.by 0

      car = Car.last

      expected = {}
      expect(response.code.to_i).to eq 401
      expect(JSON.parse(response.body)).to eq expected
    end

    it 'an error is returned when a post is made without an authentication token' do
      body = {
        "make_id" => @ford.id,
        "color" => "red",
        "doors" => 4,
        "purchased_on" => "1973-10-04"
      }.to_json

      expect { post '/cars', body, {'Accept' => 'application/json'} }.to change { Car.count }.by 0
      expect(response.code.to_i).to eq 401
      expect(JSON.parse(response.body)).to eq({})
    end

    it 'returns an error if the authentication token is invalid' do
      create_user

      body = {
        "make_id" => @ford.id,
        "color" => "red",
        "doors" => 4,
        "purchased_on" => "1973-10-04"
      }.to_json

      expect { post '/cars', body, {'Accept' => 'application/json', 'Authorization' => '12i376124876'} }.to change { Car.count }.by 0
      expect(response.code.to_i).to eq 401
      expect(JSON.parse(response.body)).to eq({})
    end
  end

end
