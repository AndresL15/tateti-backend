class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.string :name
      t.string :state
      t.string :current_symbol
      t.string :player1
      t.string :player2
      t.string :winner

      t.timestamps
    end
  end
end
