module Recordable
  include ActiveSupport::Concern

   private def create_record!(opts = {})
     Record.create!(
       status: opts[:status],
       amount: opts[:amount],
       note: opts[:note],
       reference: opts[:ref],
       bank_account_id: opts[:user].bank_account.id,
       counterpart_id: opts[:counterpart].bank_account.id
     )
   end
end
