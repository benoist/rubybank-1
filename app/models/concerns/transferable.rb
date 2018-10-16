module Transferable
  include ActiveSupport::Concern

   private def withdraw!(sender, amount)
     warn "Withdraw #{amount} from #{sender.name}'s account: #{sender.bank_account&.number}"
     adjust_balance_and_save!(sender.bank_account, -amount)
   end

   private def deposit!(recipient, amount)
     warn "Deposit #{amount} on #{recipient.name}'s account: #{recipient.bank_account&.number}"
     adjust_balance_and_save!(recipient.bank_account, amount)
   end

   private def adjust_balance_and_save!(bank_account, amount)
     bank_account.balance += amount
     bank_account.save!
   rescue NoMethodError => e
     raise StandardError, "Balance must at least be positive: #{e}"
   end
end


