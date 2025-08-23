require 'swagger_helper'

RSpec.describe 'api/v1/companies', type: :request do
  path '/api/v1/companies' do
    get('list companies') do
      tags 'Companies'
      produces 'application/json'
      response(200, 'successful') { run_test! }
    end

    post('create company') do
      tags 'Companies'
      consumes 'application/json'
      parameter name: :company, in: :body, schema: {
        type: :object,
        properties: { company: { type: :object, properties: { name: { type: :string } }, required: ['name'] } }
      }
      response(201, 'created') do
        let(:company) { { company: { name: 'Empresa XPTO' } } }
        run_test!
      end
    end
  end

  path '/api/v1/companies/{id}' do
    parameter name: :id, in: :path, type: :string

    get('show company') do
      tags 'Companies'
      produces 'application/json'
      response(200, 'successful') { run_test! }
    end

    put('update company') do
      tags 'Companies'
      consumes 'application/json'
      parameter name: :company, in: :body, schema: {
        type: :object,
        properties: { company: { type: :object, properties: { name: { type: :string } } } }
      }
      response(200, 'updated') do
        let(:id) { 1 }
        let(:company) { { company: { name: 'Empresa Atualizada' } } }
        run_test!
      end
    end

    delete('delete company') do
      tags 'Companies'
      response(204, 'deleted') do
        let(:id) { 1 }
        run_test!
      end
    end
  end
end
