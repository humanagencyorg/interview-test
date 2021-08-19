require "rails_helper"
require "money"

RSpec.describe VendingMachine do
  it "shows the balance of the money inserted" do
    vend = VendingMachine.new

    vend.deposit("$.25")
    vend.deposit("$.25")
    vend.deposit("$.25")

    expect(vend.display).to eq("$0.75")
  end

  it "allows you to purchase a soda" do
    inventory_stub = instance_double(Inventory,
                                     price: Money.new(50, :usd))
    vend = VendingMachine.new(inventory_stub)
    allow(inventory_stub).to receive(:dispense)

    vend.deposit("$.25")
    vend.deposit("$.25")
    vend.deposit("$.25")
    vend.purchase

    expect(inventory_stub).to have_received(:dispense)
  end

  it "should say thank you after you purchase" do
    inventory_stub = instance_double(Inventory,
                                     price: Money.new(50, :usd))
    vend = VendingMachine.new(inventory_stub)
    allow(inventory_stub).to receive(:dispense)

    vend.deposit("$.25")
    vend.deposit("$.25")
    vend.deposit("$.25")
    vend.purchase

    expect(vend.display).to eq("Thank you!")
  end

  context "when inadequate funds at purchase" do
    it "should display an error message" do
      inventory = Inventory.new(price: Money.new(50, :usd))
      vend = VendingMachine.new(inventory)

      vend.deposit("$.25")
      vend.purchase

      expect(vend.display).to eq("Please insert more money")
    end
  end

  context "when extra funds exist after purchase" do
    it "should return the change" do
      inventory = Inventory.new(price: Money.new(50, :usd))
      coin_stub = instance_double(CoinDispenser)
      vend = VendingMachine.new(inventory, coin_stub)
      allow(coin_stub).to receive(:return_money)

      vend.deposit("$.25")
      vend.deposit("$.25")
      vend.deposit("$.25")
      vend.purchase

      expect(coin_stub).
        to have_received(:return_money).
        with(Money.new(25, :usd))
    end

    it "should reset the balance for the next purchase" do
      inventory_stub = instance_double(Inventory, price: Money.new(50, :usd))
      vend = VendingMachine.new(inventory_stub)
      allow(inventory_stub).to receive(:dispense)

      vend.deposit("$.25")
      vend.deposit("$.25")
      vend.deposit("$.25")
      vend.deposit("$.25")
      vend.purchase
      vend.purchase

      expect(inventory_stub).not_to receive(:dispense)
    end
  end
end
