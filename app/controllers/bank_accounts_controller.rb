class BankAccountsController < ApplicationController
  def show
    @account = current_user.bank_account
  end
end
