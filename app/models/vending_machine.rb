# Vending Machine
# Accept coins or money
# Show the current balance of the machine
# Allow the user to select a beverage
# Show an error if insufficient funds
# Allow the user the ability to return coins
# Return change after purchase
# Soda is out of stock
# Exact change required

require "money"

class VendingMachine

  def initialize(inventory = Inventory.new,
                 coin_dispenser = CoinDispenser.new)
    @inventory = inventory
    @coin_dispenser = coin_dispenser
    @balance = Money.new(0, :usd)
  end

  def deposit(amount)
    @balance += Monetize.parse(amount)
    @message = @balance.format
  end

  def display
    @message
  end

  def purchase
    if @balance >= @inventory.price
      @inventory.dispense
      @message = "Thank you!"
      if @balance > @inventory.price
        returned_change = @balance - @inventory.price
        @coin_dispenser.return_money(returned_change)
        @balance -= returned_change
      end
    else
      @message = "Please insert more money"
    end
  end
end

class Inventory
  attr_reader :price

  def initialize(price: nil)
    @price = price
  end

  def dispense; end
end

class CoinDispenser
  def return_money(amount); end
end
