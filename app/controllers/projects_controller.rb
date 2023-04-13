class ProjectsController < ApplicationController
  include Crud

  def permitted_attributes
    [:name, { member_ids: [] }]
  end
end
