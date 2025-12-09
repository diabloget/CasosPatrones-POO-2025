require_relative 'interfaces'

class BaseSandwich < SandwichComponent
  def initialize(size, protein_name, price_small, price_large)
    @size = size
    @name = protein_name
    @base_price = (size == :small) ? price_small : price_large
  end

  def cost
    @base_price
  end

  def description
    "#{@name} de #{(@size == :small) ? '15 cm' : '30 cm'} ($#{cost})"
  end
end