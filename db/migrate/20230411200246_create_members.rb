class CreateMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :members do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :city
      t.string :state
      t.string :country
      t.belongs_to :team, null: false

      t.timestamps
    end
  end
end
