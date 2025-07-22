module MoneyHelper
  def format_money(cents)
    return "R$ 0,00" if cents.nil? || cents.zero?

    # Convert cents to reais
    reais = cents / 100.0

    # Format with Brazilian standard: dot for thousands, comma for decimals
    formatted = number_to_currency(reais,
                                   unit: "R$ ",
                                   separator: ",",
                                   delimiter: ".",
                                   format: "%u%n")

    formatted
  end
end
