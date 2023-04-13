require 'swagger_helper'

RSpec.describe Project, type: :request do
  path '/projects' do
    post 'Creates a project' do
      tags 'Projects'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :project, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          member_ids: { type: :array }
        },
        required: ['name']
      },
                required: true,
                description: 'Project attributes',
                example: {
                  name: 'test project',
                  member_ids: [1, 2, 3]
                }
      response '200', 'project created' do
        let(:project) { { name: 'test project' } }
        run_test! do
          expect(Project.count).to eq 1
          expect(Project.last.name).to eq project[:name]
          expect(response.status).to eq 200
        end
      end

      response '422', 'name must exist' do
        let(:project) { { name: nil } }
        run_test! do
          expect(response.status).to eq(422)
          expect(Project.count).to eq 0
        end
      end
    end

    get 'List all projects' do
      tags 'Projects'
      consumes 'application/json'
      produces 'application/json'

      response '200', 'Retrives all the projects' do
        run_test! do
          expect(response.status).to eq 200
          expect(JSON.parse(response.body)).to be_an_instance_of(Array)
        end
      end
    end
  end

  path '/projects/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Retrieves a project' do
      tags 'Projects'
      consumes 'application/json'
      produces 'application/json'

      response '200', 'project found' do
        let!(:id) { create(:project).id }
        run_test! do
          expect(response.status).to eq 200
          expect(JSON.parse(response.body)).to be_an_instance_of(Hash)
        end
      end

      response '404', 'project not found' do
        let(:id) { 'invalid' }
        run_test! do
          expect(response.status).to eq 404
          expect(JSON.parse(response.body)['error']).to eq 'Record not found'
        end
      end
    end

    patch 'Updates a project' do
      tags 'Projects'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :project, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          member_ids: { type: :array }
        },
        required: ['name']
      }

      let!(:existing_project) { create(:project, name: 'Existing Project Name') }
      let(:id) { existing_project.id }

      response '200', 'project updated' do
        let(:project) { { name: 'New Project Name' } }
        run_test! do
          expect(response.status).to eq 200
          expect(JSON.parse(response.body)).to be_an_instance_of(Hash)
          expect(JSON.parse(response.body)['resource']['name']).to eq project[:name]
        end
      end

      response '422', 'name already exist' do
        before do
          create(:project, name: 'New Project Name')
        end
        let(:project) { { name: 'New Project Name' } }
        run_test! do
          expect(response.status).to eq 422
          expect(JSON.parse(response.body)).to be_an_instance_of(Hash)
          expect(JSON.parse(response.body)['errors']).not_to be_empty
        end
      end

      response '404', 'project not found' do
        let(:project) { { name: 'New Name' } }
        let(:id) { 'invalid' }
        run_test! do
          expect(response.status).to eq 404
          expect(JSON.parse(response.body)['error']).to eq 'Record not found'
        end
      end
    end

    delete 'Deletes a project' do
      tags 'Projects'
      consumes 'application/json'
      produces 'application/json'

      response '200', 'project deleted' do
        let(:id) { create(:project).id }
        run_test! do
          expect(response.status).to eq 200
          expect(JSON.parse(response.body)['message']).to eq 'Deleted'
        end
      end

      response '404', 'project not found' do
        let(:id) { 'invalid' }
        run_test! do
          expect(response.status).to eq 404
          expect(JSON.parse(response.body)['error']).to eq 'Record not found'
        end
      end
    end
  end

  path '/projects/{project_id}/members' do
    get 'Retrieves all members for a particular Project' do
      tags 'Projects'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :project_id, in: :path, type: :string

      let!(:project) { create(:project) }
      let!(:project_id) { project.id }
      let(:members) { create_list(:member, 5, project: project) }

      response '200', 'list all the members of the project' do
        run_test! do
          expect(response.status).to eq 200
          expect(JSON.parse(response.body)).to be_an_instance_of(Array)
        end
      end

      response '404', 'project not found' do
        let(:project_id) { 'invalid' }
        run_test! do
          expect(response.status).to eq 404
          expect(JSON.parse(response.body)['error']).to eq 'Record not found'
        end
      end
    end
  end
end
