require 'swagger_helper'

RSpec.describe 'api/v1/users', type: :request do
  path '/api/v1/users' do
    get('list users (admin only)') do
      tags 'Users'
      produces 'application/json'
      security [ bearerAuth: [] ]

      response(200, 'successful') { run_test! }
      response(403, 'forbidden') { run_test! }
    end

    post('create user (admin only)') do
      tags 'Users'
      consumes 'application/json'
      security [ bearerAuth: [] ]

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
        let(:user) { { user: { name: 'Jane', email: 'jane@example.com', password: '1234', role: 'user', company_id: 1 } } }
        run_test!
      end
    end
  end

  path '/api/v1/users/{id}' do
    parameter name: :id, in: :path, type: :string

    get('show user (self or admin)') do
      tags 'Users'
      produces 'application/json'
      security [ bearerAuth: [] ]

      response(200, 'successful') { run_test! }
      response(403, 'forbidden') { run_test! }
    end

    put('update user (self or admin)') do
      tags 'Users'
      consumes 'application/json'
      security [ bearerAuth: [] ]
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: { type: :object, properties: { name: { type: :string }, email: { type: :string } } }
        }
      }

      response(200, 'updated') do
        let(:id) { 1 }
        let(:user) { { user: { name: 'Updated Name' } } }
        run_test!
      end
    end

    delete('delete user (admin only)') do
      tags 'Users'
      security [ bearerAuth: [] ]
      response(204, 'deleted') do
        let(:id) { 1 }
        run_test!
      end
    end
  end
end
