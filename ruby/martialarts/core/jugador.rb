# core/jugador.rb
class Jugador
  attr_reader :nombre, :artes_marciales
  attr_accessor :vida

  def initialize(nombre)
    @nombre = nombre
    @vida = 200
    @artes_marciales = []
  end

  # Se asegura de que la vida no baje de 0
  def recibir_dano(cantidad)
    @vida -= cantidad
    @vida = 0 if @vida < 0
  end

  # Se asegura de que la vida no exceda el máximo de 200
  def curar(cantidad)
    @vida += cantidad
    @vida = 200 if @vida > 200
  end

  def esta_vivo?
    @vida > 0
  end
  
  # Asigna 3 artes al azar de la piscina total
  def asignar_artes_marciales(artes_totales)
    @artes_marciales = artes_totales.sample(3)
  end
end