class TeamsController < ApplicationController
  include Crud

  def permitted_attributes
    [:name]
  end
end
