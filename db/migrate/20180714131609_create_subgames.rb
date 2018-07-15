class CreateSubgames < ActiveRecord::Migration[5.1]
  def change
    create_table :subgames do |t|
      t.integer :index
      t.string :winner
      t.string :board
      t.references :game

      t.timestamps
    end
  end
end
