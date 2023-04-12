class MembersController < ApplicationController
  include Crud

  def permitted_attributes
    %i[first_name last_name city state country team_id]
  end
end
