require 'swagger_helper'

RSpec.describe Project, type: :request do
  path '/projects.json' do
    post 'Creates a project' do
      tags 'Projects'
      consumes 'application/json'
      parameter name: :blog, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string }
        },
        required: ['name']
      }
      response '200', 'project created' do
        let(:blog) { { name: 'test project' } }
        run_test!
      end
    end
  end

  path 'projects/{id}' do
    post
  end
end
