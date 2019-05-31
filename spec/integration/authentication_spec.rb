require 'swagger_helper'

describe 'Authentication API' do

  path '/api/authenticate' do

    post 'Takes Household Token And Retrieves an Authentication Token' do
      tags 'Authentication'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :authentication, in: :body, schema: {
        type: :object,
        properties: {
          household_token: { type: :string }
        },
        required: %w[household_token]
      }
      response '200', 'Returns authentication_token' do
        it 'Authenticate successfully' do
          thermostat = create(:thermostat)
          post api_authenticate_path, params: { household_token: thermostat.household_token }
          expect(response).to have_http_status(:success)
          expect(JSON.parse(response.body)['authentication_token']).to eq(thermostat.auth_token)
        end
      end

      response '401', 'Invalid Household Token' do
        it 'Authenticate with invalid household_token' do
          post api_authenticate_path, params: { household_token: 'Invalid Token' }
          expect(response).to have_http_status(:unauthorized)
          expect(JSON.parse(response.body)['error']['message']).to eq('Invalid Household Token')
        end
      end

      response '422', 'Required Household Token' do
        it 'Authenticate with no params' do
          post api_authenticate_path
          expect(response).to have_http_status(:unprocessable_entity)
          expect(JSON.parse(response.body)['error']['message']).to eq('Required Household Token')
        end
      end
    end
  end
end
