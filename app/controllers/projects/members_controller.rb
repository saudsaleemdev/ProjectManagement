module Projects
  class MembersController < ApplicationController
    def index
      @members = project.members
      respond_to do |format|
        format.html
        format.json { render json: @members }
      end
    end

    private

    def project
      @project ||= Project.includes(:members).find(params[:project_id])
    end
  end
end
