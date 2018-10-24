class TransfersController < ApplicationController
  def new
    @users = User.where.not(id: current_user.id)
  end

  def create
    @transfer = Transfer.transfer(current_user, transfer_params)

    respond_to do |format|
      if @transfer.save
        format.html { redirect_to root_path, notice: 'Transfered successfully.' }
      else
        format.html { render :new }
      end
    end
  rescue ActiveRecord::RecordNotFound => e
    warn "🛑 #{([e.inspect]+e.backtrace).join($/)}"
    redirect_to '/transfers/new', alert: "Record not found: #{e}"
  rescue ArgumentError => e
    warn "🛑 #{([e.inspect]+e.backtrace).join($/)}"
    redirect_to '/transfers/new', alert: "Amount can not be empty! #{e}"
  rescue StandardError => e
    warn "🛑 #{([e.inspect]+e.backtrace).join($/)}"
    redirect_to '/transfers/new', alert: e
  end

  private

  def transfer_params
    params.permit(:recipient, :amount, :note)
  end
end
