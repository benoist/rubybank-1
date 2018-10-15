class Transfer
  def self.transfer(params)
    sender ||= User.find(params[:sender].to_i)
    recipient ||= User.find(params[:recipient].to_i)
    amount ||= BigDecimal(params[:amount])
    note ||= params[:note] if params[:note] != ''
    ref ||= SecureRandom.hex(7)

    warn "Transfer #{amount} from #{sender.name} to #{recipient.name}"
    return false unless amount_valid?(amount)
    begin
      BankAccount.transaction do
        withdraw!(sender, amount)
        create_record!(status: :transfered, user: sender, counterpart: recipient,
                       amount: amount, ref: ref, note: note)
        deposit!(recipient, amount)
        create_record!(status: :received, user: recipient, counterpart: sender,
                       amount: amount, ref: ref, note: note)
      end
    rescue StandardError => e
      warn "⚠️ #{([e.inspect]+e.backtrace).join($/)}"
      reload_accounts_and_records(sender, recipient)
      warn '❌ Transaction and objects state reverted!'
      raise
    end
  end

  private

  def self.amount_valid?(amount)
    if amount <= 0
      warn '❌ Transaction aborted! No negative amounts allowed.'
      return false
    end
    true
  end

  def self.withdraw!(sender, amount)
    warn "Withdraw #{amount} from #{sender.name}'s account: #{sender.bank_account&.number}"
    adjust_balance_and_save!(sender.bank_account, -amount)
  end

  def self.deposit!(recipient, amount)
    warn "Deposit #{amount} on #{recipient.name}'s account: #{recipient.bank_account&.number}"
    adjust_balance_and_save!(recipient.bank_account, amount)
  end

  def self.adjust_balance_and_save!(bank_account, amount)
    bank_account.balance += amount
    bank_account.save!
  rescue NoMethodError => e
    raise StandardError, "Balance must at least be positive: #{e}"
  end

  def self.create_record!(opts = {})
    Record.create!(
      status: opts[:status],
      amount: opts[:amount],
      note: opts[:note],
      reference: opts[:ref],
      bank_account_id: opts[:user].bank_account.id,
      counterpart_id: opts[:counterpart].bank_account.id
    )
  end

  def self.reload_accounts_and_records(sender, recipient)
    # this method keeps the memory and database in-sync after a rollback event!
    # if there are no records that correspond at all it will silently go on
    # because there is nothing to reload.
    [sender, recipient].each do |user|
      user.reload&.bank_account
      user.reload&.bank_account&.records
    end
  end
end
