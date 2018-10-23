class Transfer
  include Reloadable
  include AmountValidatable
  include Recordable
  include Transferable

  attr_reader :sender, :recipient, :amount, :note, :ref

  def initialize(sender, params = {})
    @sender = sender
    @recipient = User.find(params[:recipient].to_i)
    @amount = BigDecimal(params[:amount])
    @note ||= params[:note] if params[:note] != ''
    @ref = SecureRandom.hex(7)
  end

  def self.transfer(sender, params = {})
    new(sender, params).send(:transfer)
  end

  private

  def transfer
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
      warn "⚠️ #{([e.inspect] + e.backtrace).join($INPUT_RECORD_SEPARATOR)}"
      reload_accounts_and_records(sender, recipient)
      warn '❌ Transaction and objects state reverted!'
      raise
    end
  end
end
