require 'swagger_helper'

RSpec.describe Team, type: :request do
  path '/teams' do
    post 'Creates a team' do
      tags 'Teams'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :team, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string }
        },
        required: ['name']
      },
                required: true,
                description: 'Team attributes',
                example: {
                  name: 'test team'
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
      response '200', 'team created' do
        let!(:team) { { name: 'Test Team' } }
        run_test! do
          expect(Team.count).to eq 1
          expect(Team.last.name).to eq team[:name]
          expect(response.status).to eq 200
        end
      end

      response '422', 'if name missing' do
        let!(:team) { { name: nil } }
        run_test! do
          expect(response.status).to eq(422)
          expect(Team.count).to eq 0
        end
      end
    end

    get 'Retrieves all teams' do
      tags 'Teams'
      consumes 'application/json'
      produces 'application/json'

      response '200', 'retrive all the teams' do
        run_test! do
          expect(response.status).to eq 200
          expect(JSON.parse(response.body)).to be_an_instance_of(Array)
        end
      end
    end
  end

  path '/teams/{id}' do
    parameter name: :id, in: :path, type: :integer

    get 'Retrieves a team' do
      tags 'Teams'
      consumes 'application/json'
      produces 'application/json'

      response '200', 'team found' do
        let(:id) { create(:team).id }
        run_test! do
          expect(response.status).to eq 200
          expect(JSON.parse(response.body)).to be_an_instance_of(Hash)
        end
      end

      response '404', 'team not found' do
        let(:id) { 'invalid' }
        run_test! do
          expect(response.status).to eq 404
          expect(JSON.parse(response.body)['error']).to eq 'Record not found'
        end
      end
    end

    put 'Updates a team' do
      tags 'Teams'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :team, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string }
        },
        required: ['name']
      }

      let!(:existing_team) { create(:team, name: 'existing team Name') }
      let(:id) { existing_team.id }
      response '200', 'team updated' do
        let(:team) { { name: 'New Name' } }
        run_test! do
          expect(response.status).to eq 200
          expect(JSON.parse(response.body)).to be_an_instance_of(Hash)
          expect(JSON.parse(response.body)['resource']['name']).to eq team[:name]
        end
      end

      response '422', 'invalid request' do
        before do
          create(:team, name: 'new team Name')
        end
        let(:team) { { name: 'new team Name' } }
        run_test! do
          expect(response.status).to eq 422
          expect(JSON.parse(response.body)).to be_an_instance_of(Hash)
          expect(JSON.parse(response.body)['errors']).not_to be_empty
        end
      end

      response '404', 'team not found' do
        let(:team) { { name: 'New Name' } }
        let(:id) { 'invalid' }
        run_test! do
          expect(response.status).to eq 404
          expect(JSON.parse(response.body)['error']).to eq 'Record not found'
        end
      end
    end

    delete 'Deletes a team' do
      tags 'Teams'
      consumes 'application/json'
      produces 'application/json'

      response '200', 'team deleted' do
        let(:id) { create(:team).id }
        run_test! do
          expect(response.status).to eq 200
          expect(JSON.parse(response.body)['message']).to eq 'Deleted'
        end
      end

      response '404', 'team not found' do
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
end
