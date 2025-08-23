require 'swagger_helper'

RSpec.describe 'api/v1/users', type: :request do
  path '/api/v1/users' do
    get('list users') do
      tags 'Users'
      produces 'application/json'
      response(200, 'successful') { run_test! }
    end

    post('create user') do
      tags 'Users'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              name: { type: :string },
              email: { type: :string }
            },
            required: ['name', 'email']
          }
        }
      }
      response(201, 'created') do
        let(:user) { { user: { name: 'John Doe', email: 'john@example.com' } } }
        run_test!
      end
    end
  end

  path '/api/v1/users/{id}' do
    parameter name: :id, in: :path, type: :string

    get('show user') do
      tags 'Users'
      produces 'application/json'
      response(200, 'successful') { run_test! }
    end

    put('update user') do
      tags 'Users'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          user: { type: :object, properties: { name: { type: :string }, email: { type: :string } } }
        }
      }
      response(200, 'updated') do
        let(:id) { 1 }
        let(:user) { { user: { name: 'Jane Doe', email: 'jane@example.com' } } }
        run_test!
      end
    end

    delete('delete user') do
      tags 'Users'
      response(204, 'deleted') do
        let(:id) { 1 }
        run_test!
      end
    end
  end
end
