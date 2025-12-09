# Componente base abstracto
class SandwichComponent
  attr_reader :size # :small (15cm) o :large (30cm)

  def cost
    raise NotImplementedError
  end

  def description
    raise NotImplementedError
  end
end