require 'swagger_helper'

RSpec.describe 'api/v1/tasks', type: :request do
  path '/api/v1/tasks' do
    get('list tasks') do
      tags 'Tasks'
      produces 'application/json'
      security [ bearerAuth: [] ]
      response(200, 'successful') { run_test! }
    end

    post('create task') do
      tags 'Tasks'
      consumes 'application/json'
      security [ bearerAuth: [] ]
      parameter name: :task, in: :body, schema: {
        type: :object,
        properties: {
          task: {
            type: :object,
            properties: {
              title: { type: :string },
              description: { type: :string },
              status: { type: :string },
              user_id: { type: :integer },
              company_id: { type: :integer }
            },
            required: ['title']
          }
        }
      }

      response(201, 'created') do
        let(:task) { { task: { title: 'Task 1', description: 'Sample', status: 'open', user_id: 1, company_id: 1 } } }
        run_test!
      end
    end
  end

  path '/api/v1/tasks/{id}' do
    parameter name: :id, in: :path, type: :string

    get('show task') do
      tags 'Tasks'
      produces 'application/json'
      security [ bearerAuth: [] ]
      response(200, 'successful') { run_test! }
      response(403, 'forbidden') { run_test! }
    end

    put('update task') do
      tags 'Tasks'
      consumes 'application/json'
      security [ bearerAuth: [] ]
      parameter name: :task, in: :body, schema: {
        type: :object,
        properties: { task: { type: :object, properties: { title: { type: :string }, description: { type: :string } } } }
      }

      response(200, 'updated') do
        let(:id) { 1 }
        let(:task) { { task: { title: 'Updated Task', description: 'Updated Desc' } } }
        run_test!
      end
    end

    delete('delete task') do
      tags 'Tasks'
      security [ bearerAuth: [] ]
      response(204, 'deleted') do
        let(:id) { 1 }
        run_test!
      end
    end
  end
end
