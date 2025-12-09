require_relative 'interfaces'

# Decorador Base
class IngredientDecorator < SandwichComponent
  def initialize(sandwich_component)
    @sandwich = sandwich_component
  end

  def size
    @sandwich.size # Delegamos el tamaño al sandwich base
  end

  def cost
    @sandwich.cost # Se sobreescribe en los hijos
  end

  def description
    @sandwich.description # Se sobreescribe en los hijos
  end
end

# Decorador Concreto (Ingrediente genérico)
class ExtraIngredient < IngredientDecorator
  def initialize(sandwich, name, price_small, price_large)
    super(sandwich)
    @name = name
    @price = (sandwich.size == :small) ? price_small : price_large
  end

  def cost
    super + @price
  end

  def description
    super + " + #{@name} ($#{@price})"
  end
end