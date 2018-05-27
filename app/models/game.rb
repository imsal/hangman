class Game < ApplicationRecord
  before_validation :random_word
  before_save :upcase_word
  validates :word, length: { minimum: 2, maximum: 12 }, presence: true, format: { with: /\A[a-zA-Z]+\z/, message: "can only be a single word made of letters with no numbers, special characters, or spaces." }

  private

  def upcase_word
    self.word = self.word.upcase
  end

  def random_word
    if self.word.blank?
      self.word = LiterateRandomizer.word
    end
  end

end
