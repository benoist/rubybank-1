class BankAccount < ApplicationRecord
  belongs_to :user
  has_many :records, dependent: :destroy
  validates :user, presence: true
  validates :balance, numericality: { greater_than_or_equal_to: 0 }
  before_commit :generate_bank_account_number, on: :create

  private

  def generate_bank_account_number
    self.number = "ROR5BNK000#{id}" # For simplicity's sake, could be a SHA256!
  end
end
