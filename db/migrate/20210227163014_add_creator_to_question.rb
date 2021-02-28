class AddCreatorToQuestion < ActiveRecord::Migration[5.2]
  def change
    add_reference :questions, :creator, foreign_key: { to_table: :users }, index: true
  end
end
