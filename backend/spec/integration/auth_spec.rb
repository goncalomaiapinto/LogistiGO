require 'swagger_helper'

RSpec.describe 'api/v1/auth', type: :request do
  path '/api/v1/auth/login' do
    post('login') do
      tags 'Auth'
      consumes 'application/json'
      parameter name: :credentials, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string }
        },
        required: ['email', 'password']
      }

      response(200, 'successful') do
        let(:credentials) { { email: 'john@example.com', password: '1234' } }
        run_test!
      end

      response(401, 'unauthorized') do
        let(:credentials) { { email: 'wrong@example.com', password: 'fail' } }
        run_test!
      end
    end
  end

  path '/api/v1/auth/register' do
    post('register') do
      tags 'Auth'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              name: { type: :string },
              email: { type: :string },
              password: { type: :string },
              role: { type: :string, enum: ['admin', 'user'] },
              company_id: { type: :integer }
            },
            required: ['name', 'email', 'password']
          }
        }
      }

      response(201, 'created') do
        let(:user) { { user: { name: 'John', email: 'john@example.com', password: '1234', role: 'user', company_id: 1 } } }
        run_test!
      end
    end
  end

  path '/api/v1/auth/logout' do
    post('logout') do
      tags 'Auth'
      produces 'application/json'
      response(200, 'successful') { run_test! }
    end
  end
end
