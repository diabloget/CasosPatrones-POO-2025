# core/golpe.rb
class Golpe
  attr_reader :nombre, :poder, :cura_propia, :dano_extra

  def initialize(nombre, poder, cura_propia = 0, dano_extra = 0)
    @nombre = nombre
    @poder = poder
    @cura_propia = cura_propia
    @dano_extra = dano_extra
  end

  def ejecutar(atacante, defensor)
    dano_total = @poder + @dano_extra
    
    # El defensor DEBE existir y el atacante DEBE poder curarse
    defensor.recibir_dano(dano_total)
    atacante.curar(@cura_propia) if @cura_propia > 0
    
    # Generación de bitácora
    resultado = "#{@nombre} (Daño: #{dano_total})"
    resultado += " [Cura J1: + #{@cura_propia}]" if @cura_propia > 0
    resultado += " [Extra: + #{@dano_extra}]" if @dano_extra > 0
    resultado
  end


  def ejecutar_con_retorno(atacante, defensor)
    dano_total = @poder + @dano_extra
    defensor.recibir_dano(dano_total)
    atacante.curar(@cura_propia) if @cura_propia > 0
    
    txt = "#{@nombre} -> -#{dano_total} HP"
    txt += " (Curado + #{@cura_propia})" if @cura_propia > 0
    txt += " (Crítico + #{@dano_extra})" if @dano_extra > 0
    
    return txt, dano_total
  end
end