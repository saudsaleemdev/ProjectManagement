module Teams
  class MembersController < ApplicationController
    def index
      @team = Team.find(params[:team_id])
      @members = @team.members
    end

    def new
      @team = Team.find(params[:team_id])
    end
  end
end
