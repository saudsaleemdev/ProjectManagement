class AddUniqueIndexToProjectMembers < ActiveRecord::Migration[6.1]
  def change
    add_index :project_members, %i[project_id member_id], unique: true
  end
end
