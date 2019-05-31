require 'swagger_helper'

describe 'Reading API' do
  let(:cache) { Rails.cache }

  before(:each) do
    @thermostat = create(:thermostat)
    cache.clear
  end

  path '/api/readings' do

    post 'Creates a reading' do
      tags 'Readings'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :Authorization, required: :true, in: :header, type: :string, description: 'Authorization <auth_token>'
      parameter name: :reading, in: :body, schema: {
        type: :object,
        properties: {
          temperature: { type: :float },
          humidity: { type: :float },
          battery_charge: { type: :float }
        },
        required: %w[thermostat_id temperature humidity battery_charge']
      }
      response '201', 'reading created' do
        it 'should return 201 with the new sequence_number of the current thermostat as a reading_id' do
          reading_params = {temperature: 1, humidity: 2, battery_charge: 3}
          sequence_number = 
          allow(ThermostatCachingService).to receive(:update_reading_number).and_return(sequence_number)
          allow(ThermostatCachingService).to receive(:cache_new_reading)
          post api_readings_path, params: {reading: reading_params},
               headers: { 'Authorization': "Authorization #{@thermostat.auth_token}" }
          expect(response).to have_http_status(:success)
          expect(JSON.parse(response.body)).to eq({ "reading_id" => sequence_number })
        end
      end

      response '422', 'invalid record' do
        it 'should return 422 if reading is not valid' do
          post api_readings_path, params: {reading: {temperature: '', humidity: '', battery_charge: ''}},
                                  headers: { 'Authorization': "Authorization #{@thermostat.auth_token}" }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end
  end

  path '/api/readings/{id}' do
    get 'Retrieves a reading' do
      tags 'Readings'
      produces 'application/json'
      parameter name: :Authorization, required: :true, in: :header, type: :string, description: 'Authorization <auth_token>'
      parameter name: :id, required: :true, in: :path, type: :string, description: 'Reading Id (Required)'
      response '200', 'reading found' do
        it 'reading should be read from cache' do
          cache.write("#{@thermostat.id}/1", { key: :value })
          get api_reading_path(id: 1), headers: { 'Authorization': "Authorization #{@thermostat.auth_token}" }
          expect(response).to have_http_status(:success)
          expect(JSON.parse(response.body)).to eq({ 'key' => 'value' })
        end

        it 'reading should be read from db if no cache' do
          reading = create(:reading, thermostat: @thermostat)
          get api_reading_path(id: reading.number), headers: { 'Authorization': "Authorization #{@thermostat.auth_token}" }
          expect(response).to have_http_status(:success)
          expect(JSON.parse(response.body)).to eq(reading.attributes)
        end
      end

      response '404', 'reading not found' do
        it 'returns 404 on non exists id parameter' do
          get api_reading_path(id: 1), headers: { 'Authorization': "Authorization #{@thermostat.auth_token}" }
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
