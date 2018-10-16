module AmountValidatable
  include ActiveSupport::Concern

  private def amount_valid?(amount)
    if amount <= 0
      warn '❌ Transaction aborted! No negative amounts allowed.'
      return false
    end
    true
  end
end
