module ApplicationHelper
  def amount_formater(amount)
    if amount < 0
      format '%.2f', amount.round(2)
    elsif amount > 0
      "+#{format('%.2f', amount.round(2))}"
    end
  end
end
