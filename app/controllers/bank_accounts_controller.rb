class BankAccountsController < ApplicationController
  before_action :set_params, only: [:create!]

  def create!(params)
    bank_account = BankAccount.new(params)
    warn "Creating an account with #{bank_account.attributes}"
    bank_account.save!
  end

  def show
    @account = current_user.bank_account
    @records = current_user&.records
  end

  private

  def set_params
    params.require(:bank_account).permit(:id, :user_id, :created_at, :updated_at)
  end
end
