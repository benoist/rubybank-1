module Reloadable
  include ActiveSupport::Concern

  private def reload_accounts_and_records(sender, recipient)
    # this method keeps the memory and database in-sync after a rollback event!
    # if there are no records that correspond at all it will silently go on
    # because there is nothing to reload.
    [sender, recipient].each do |user|
      user.reload&.bank_account
      user.reload&.bank_account&.records
    end
  end
end
