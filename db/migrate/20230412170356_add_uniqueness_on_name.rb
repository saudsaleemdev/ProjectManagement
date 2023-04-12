class AddUniquenessOnName < ActiveRecord::Migration[6.1]
  def change
    add_index :members, %i[first_name last_name], unique: true
    add_index :teams, :name, unique: true
    add_index :projects, :name, unique: true
  end
end
