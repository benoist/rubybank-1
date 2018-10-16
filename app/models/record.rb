class Record < ApplicationRecord
  belongs_to :bank_account
  belongs_to :counterpart, class_name: 'BankAccount'
  validates :amount, numericality: { greater_than_or_equal_to: 0 }
  before_save :default_note, on: :create
  before_save :decorate_amount, on: :create

  private

  def decorate_amount
    status == 'received' ? (self.amount = amount.to_s) : (self.amount = "-#{amount}")
  end

  def default_note
    ft = (status == 'received')
    self.note ||= "#{status.to_s.humanize}: #{amount} "\
                "#{ft ? 'From:' : 'To:'} #{counterpart.user.name.humanize}"
  end
end
