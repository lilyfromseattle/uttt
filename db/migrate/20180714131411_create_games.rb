class CreateGames < ActiveRecord::Migration[5.1]
  def change
    create_table :games do |t|
      t.string :turn
      t.integer :last_move
      t.string :winner

      t.timestamps
    end
  end
end
