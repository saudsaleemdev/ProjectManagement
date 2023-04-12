class TeamsController < ApplicationController
  include Resourceable

  before_action :find_team, only: [:members]

  def members
    respond_to do |format|
      format.html
      format.json { render json: @team.members }
    end
  end

  def permitted_attributes
    [:name]
  end

  private

  def find_team
    @team = Team.find(params[:id])
  end
end
