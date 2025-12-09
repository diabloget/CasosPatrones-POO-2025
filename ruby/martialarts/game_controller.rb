require_relative 'core/golpe'
require_relative 'core/arte_marcial'
require_relative 'core/jugador'

class GameController
  attr_reader :jugador1, :jugador2, :bitacora, :todas_artes, :turno_actual

  def initialize
    @todas_artes = [
      Karate.new, TaeKwonDo.new, MuayThai.new, JiuJitsu.new, BoxeoChino.new,
      Capoeira.new, KravMaga.new, Judo.new, WingChun.new, Sambo.new
    ]
    
    @jugador1 = Jugador.new("Jugador 1")
    @jugador2 = Jugador.new("Jugador 2")
    
    @jugador1.asignar_artes_marciales(@todas_artes)
    @jugador2.asignar_artes_marciales(@todas_artes)
    
    @bitacora = []
    
    # Inicio aleatorio (1 o 2)
    @turno_actual = [1, 2].sample
    @bitacora << "-: Se le da inicio a los guamazos!"
    @bitacora << "-: Los dioses del RNG seleccionaron al Jugador #{@turno_actual}"
  end

  def cambiar_turno
    @turno_actual = (@turno_actual == 1) ? 2 : 1
  end

  def reasignar_artes(jugador)
    jugador.asignar_artes_marciales(@todas_artes)
  end

  # JUGADOR 1: Elige Estrategia Específica
  def ataque_jugador1(arte_marcial_index)
    return unless @turno_actual == 1 && juego_activo?
    
    arte = @jugador1.artes_marciales[arte_marcial_index]
    ejecutar_ataque(@jugador1, @jugador2, arte)
    cambiar_turno
  end

  # JUGADOR 2: Elige atacar (Arte aleatorio segun espe)
  def ataque_jugador2
    return unless @turno_actual == 2 && juego_activo?
    
    # Según la espe, J2 debe de usar cualquiera de SUS artes al azar
    arte = @jugador2.artes_marciales.sample
    ejecutar_ataque(@jugador2, @jugador1, arte)
    cambiar_turno
  end

  # Lógica común de ejecución de combo
  def ejecutar_ataque(atacante, defensor, arte)
    num_golpes = rand(3..6)
    
    @bitacora << "------------------------------------------------"
    @bitacora << "Turno #{atacante.nombre} | Estilo: #{arte.nombre.upcase}"
    
    total_dano_turno = 0
    
    num_golpes.times do |i|
      golpe = arte.golpes.sample
      resultado_str, dano = golpe.ejecutar_con_retorno(atacante, defensor)
      total_dano_turno += dano
      
      @bitacora << "   #{i+1}. #{resultado_str}"
      
      break unless defensor.esta_vivo?
    end
    
    @bitacora << "   [RESULTADO] Daño total: #{total_dano_turno} | HP Restante Rival: #{defensor.vida}"
  end

  def reiniciar
    @jugador1.vida = 200
    @jugador2.vida = 200
    @jugador1.asignar_artes_marciales(@todas_artes)
    @jugador2.asignar_artes_marciales(@todas_artes)
    @bitacora.clear
    @turno_actual = [1, 2].sample
    @bitacora << "-: JUEGO REINICIADO. Turno inicial: Jugador #{@turno_actual}"
  end

  def juego_activo?
    @jugador1.esta_vivo? && @jugador2.esta_vivo?
  end

  def verificar_ganador
    return "¡JUGADOR 2 HA GANADO!" unless @jugador1.esta_vivo?
    return "¡JUGADOR 1 HA GANADO!" unless @jugador2.esta_vivo?
    nil
  end
end