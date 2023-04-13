module Teams
  class MembersController < ApplicationController
    before_action :team, only: :index

    def index
      @members = @team.members
      respond_to do |format|
        format.html
        format.json { render json: @members }
      end
    end

    private

    def team
      @team ||= Team.find(params[:team_id])
    end
  end
end
