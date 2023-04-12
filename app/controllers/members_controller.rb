class MembersController < ApplicationController
  include Resourceable

  def permitted_attributes
    %i[first_name last_name city state country team_id]
  end
end
