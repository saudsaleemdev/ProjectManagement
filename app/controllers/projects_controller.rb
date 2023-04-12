class ProjectsController < ApplicationController
  include Crud

  def members
    respond_to do |format|
      format.html
      format.json { render json: project_with_members.members }
    end
  end

  def add_member
    find_project
    if @resource.members << member
      respond_to do |format|
        format.html { redirect_to redirect_to_path, notice: 'Updated' }
        format.json { render json: { message: 'Updated' } }
      end
    else
      respond_with_error(@project)
    end
  end

  def permitted_attributes
    [:name]
  end

  private

  def find_project
    @resource = Project.find(params[:project_id])
  end

  def member
    @member ||= Member.find(params[:id])
  end

  def project_with_members
    @project_with_members ||= Project.includes(:members).find(params[:project_id])
  end
end
