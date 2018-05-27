class AddLetterGuessesToGames < ActiveRecord::Migration[5.1]
  def change
    add_column :games, :letter_guesses, :string, default: ''
  end
end
