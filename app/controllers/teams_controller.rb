class TeamsController < ApplicationController
  include Crud

  before_action :find_team, only: [:members]

  def members
    @members = @team.members
    respond_to do |format|
      format.html
      format.json { render json: @members }
    end
  end

  def permitted_attributes
    [:name]
  end

  private

  def find_team
    @team = Team.find(params[:team_id])
  end
end
