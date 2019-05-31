require 'swagger_helper'

describe 'Thermostat API' do
  let(:cache) { Rails.cache }

  before(:each) do
    @thermostat = create(:thermostat)
    cache.clear
  end

  path '/api/thermostats/statistics' do
    get 'Retrieves thermostat statistics' do
      tags 'Thermostats'
      produces 'application/json'
      parameter name: :Authorization, required: :true, in: :header, type: :string, description: 'Authorization <auth_token>'
      response '200', 'Return Thermostats Reading Statistics' do
        it 'should has no statistics if thermostat has no readings' do
          get api_statistics_path, headers: { 'Authorization': "Authorization #{@thermostat.auth_token}" }
          expect(response).to have_http_status(:success)
          expect(JSON.parse(response.body)).to eq({})
        end

        it 'statistics should be read from cache' do
          cache.write("thermo_#{@thermostat.id}_statistics", { key: :value })
          get api_statistics_path, headers: { 'Authorization': "Authorization #{@thermostat.auth_token}" }
          expect(response).to have_http_status(:success)
          expect(JSON.parse(response.body)).to eq({ 'key' => 'value' })
        end

        it 'statistics should return reading data if cache is clear' do
          reading = create(:reading, thermostat: @thermostat)
          get api_statistics_path, headers: { 'Authorization': "Authorization #{@thermostat.auth_token}" }
          expect(response).to have_http_status(:success)
          expected_response = {}
          %w[temperature humidity battery_charge].each do |property|
            expected_response["min_#{property}"] = reading.send(property)
            expected_response["max_#{property}"] = reading.send(property)
            expected_response["average_#{property}"] = reading.send(property)
          end
          expect(JSON.parse(response.body)).to eq(expected_response)
        end
      end
    end
  end
end
