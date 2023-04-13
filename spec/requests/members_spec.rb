require 'swagger_helper'

RSpec.describe Member, type: :request do
  path '/members' do
    post 'Creates a member' do
      tags 'Members'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :member, in: :body,
      schema: {
        type: :object,
        properties: {
          first_name: { type: :string },
          last_name: { type: :string },
          city: { type: :string },
          state: { type: :string },
          country: { type: :string },
          team_id: { type: :integer }
        },
        required: %w[first_name last_name team_id]
      },
      required: true,
      description: 'Member attributes',
      example: {
        first_name: 'John',
        last_name: 'Doe',
        city: 'New York',
        state: 'NY',
        country: 'USA',
        team_id: 1
      },
      headers: {
        'Content-Type' => {
          description: 'The format of the request payload',
          type: :string,
          example: 'application/json'
        },
        'Accept' => {
          description: 'The format of the response payload',
          type: :string,
          example: 'application/json'
        }
      }

      response '200', 'member created' do
        let(:team) { create(:team) }
        let!(:member) { { first_name: 'test', last_name: 'project', team_id: team.id } }
        run_test! do
          expect(Member.count).to eq 1
          expect(Member.last.first_name).to eq member[:first_name]
          expect(response.status).to eq 200
        end
      end

      response '422', 'invalid request' do
        let(:member) { { first_name: nil } }
        run_test! do
          expect(response.status).to eq(422)
          expect(Member.count).to eq 0
        end
      end
    end

    get 'List all Members' do
      tags 'Members'
      consumes 'application/json'
      produces 'application/json'

      response '200', 'members listed' do
        let!(:member) { create(:member) }
        run_test! do
          expect(response.status).to eq 200
          expect(JSON.parse(response.body)).to be_an_instance_of(Array)
        end
      end
    end
  end

  path '/members/{id}' do
    parameter name: :id, in: :path, type: :integer
    get 'Retrieves a member' do
      tags 'Members'
      consumes 'application/json'
      produces 'application/json'

      let!(:member) { create(:member) }
      response '200', 'member found' do
        let!(:id) { member.id }

        run_test! do
          expect(response.status).to eq 200
          expect(JSON.parse(response.body)).to be_an_instance_of(Hash)
        end
      end

      response '404', 'member not found' do
        let(:id) { 'invalid' }
        run_test! do
          expect(response.status).to eq 404
          expect(JSON.parse(response.body)['error']).to eq 'Record not found'
        end
      end
    end

    patch 'Updates a member' do
      tags 'Members'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :member, in: :body, schema: {
        type: :object,
        properties: {
          first_name: { type: :string },
          last_name: { type: :string },
          city: { type: :string },
          state: { type: :string },
          country: { type: :string },
          team_id: { type: :integer }
        },
        required: %w[first_name last_name team_id]
      }

      let!(:existing_member) { create(:member) }
      let(:id) { existing_member.id }

      response '200', ' member updated' do
        let(:member) { { first_name: 'updated', last_name: ' member' } }
        run_test! do
          expect(response.status).to eq 200
          expect(JSON.parse(response.body)).to be_an_instance_of(Hash)
          expect(JSON.parse(response.body)['resource']['first_name']).to eq member[:first_name]
        end
      end

      response '422', 'invalid request' do
        before do
          create(:member, first_name: 'test', last_name: 'name')
        end
        let(:member) { { first_name: 'test', last_name: 'name' } }
        run_test! do
          expect(response.status).to eq 422
          expect(JSON.parse(response.body)).to be_an_instance_of(Hash)
          expect(JSON.parse(response.body)['errors']).not_to be_empty
        end
      end

      response '404', 'project not found' do
        let(:member) { { first_name: 'test', last_name: 'name' } }
        let(:id) { 'invalid' }
        run_test! do
          expect(response.status).to eq 404
          expect(JSON.parse(response.body)['error']).to eq 'Record not found'
        end
      end
    end

    delete 'Deletes a member' do
      tags 'Members'
      consumes 'application/json'
      produces 'application/json'

      response '200', 'member deleted' do
        let(:id) { create(:member).id }
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

  path '/teams/{team_id}/members' do
    get 'Retrieves all members for a particular team' do
      tags 'Teams'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :team_id, in: :path, type: :integer

      let(:team) { create(:team) }
      let(:team_id) { team.id }
      let(:members) { create_list(:member, 5, team: team) }
      response '200', 'lists all members for a team' do
        run_test! do
          expect(response.status).to eq 200
          expect(JSON.parse(response.body)).to be_an_instance_of(Array)
        end
      end

      response '404', 'invalid team id' do
        let(:team_id) { 'invalid' }
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

      response '404', 'invalid project id' do
        let(:project_id) { 'invalid' }
        run_test! do
          expect(response.status).to eq 404
          expect(JSON.parse(response.body)['error']).to eq 'Record not found'
        end
      end
    end
  end
end
