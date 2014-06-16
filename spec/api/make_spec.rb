require 'rails_helper'

describe "Make API" do

  describe 'GET /makes' do
    it 'returns a list of makes' do
      ford = create_make(name: "Ford")
      chevy = create_make(name: "Chevy")

      get '/makes', {}, {'Accept' => 'application/json'}

      expected_response = {
        "_links" => {
          "self" => {"href" => makes_path},
        },
        "_embedded" => {
          "makes" => [
            {
              "_links" => {
                "self" => {"href" => make_path(ford)},
              },
              "id" => ford.id,
              "name" => "Ford"
            },
            {
              "_links" => {
                "self" => {"href" => make_path(chevy)},
              },
              "id" => chevy.id,
              "name" => "Chevy"
            },
          ]
        },
      }

      expect(response.code.to_i).to eq 200
      expect(JSON.parse(response.body)).to eq(expected_response)
    end
    it 'returns a list of makes in XML format' do
      ford = create_make(name: "Ford")
      chevy = create_make(name: "Chevy")

      get '/makes', {}, {'Accept' => 'application/xml'}

      expected_response = <<-INPUT
<apiResponse>
  <links>
    <self href="/makes"/>
  </links>
  <makes>
    <make>
      <links>
        <self href="/makes/#{ford.id}"/>
      </links>
      <id>#{ford.id}</id>
      <name>Ford</name>
    </make>
    <make>
      <links>
        <self href="/makes/#{chevy.id}"/>
      </links>
      <id>#{chevy.id}</id>
      <name>Chevy</name>
    </make>
  </makes>
</apiResponse>
      INPUT

      expect(response.code.to_i).to eq 200
      expect(response.body).to eq(expected_response)
    end
  end

  describe 'GET /makes/:id' do
    it 'returns one make' do
      ford = create_make(name: "Ford")

      get "/makes/#{ford.id}", {}, {'Accept' => 'application/json'}

      expected_response = {
        "_links" => {
          "self" => {"href" => make_path(ford)},
        },
        "id" => ford.id,
        "name" => "Ford"
      }

      expect(response.code.to_i).to eq 200
      expect(JSON.parse(response.body)).to eq(expected_response)
    end

    it 'returns one make' do
      ford = create_make(name: "Ford")

      get "/makes/#{ford.id}", {}, {'Accept' => 'application/xml'}

      expected_response = <<-INPUT
<apiResponse>
  <links>
    <self href="/makes/#{ford.id}"/>
  </links>
  <make>
    <id>#{ford.id}</id>
    <name>Ford</name>
  </make>
</apiResponse>
      INPUT

      expect(response.code.to_i).to eq 200
      expect(response.body).to eq(expected_response)
    end
  end
end
