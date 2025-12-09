require_relative 'golpe' 

# Patrón Strategy - Interfaz de Arte Marcial
# Define la estructura base que toda estrategia (arte) debe seguir.
class ArteMarcial
  attr_reader :nombre, :golpes

  def initialize(nombre)
    @nombre = nombre
    @golpes = []
  end
end


# Estrategias Concretas (Las 10 Artes Marciales)

# 1. Karate: Mae Geri, Yoko geri.
class Karate < ArteMarcial
  def initialize
    super("Karate")
    @golpes = [
      Golpe.new("Gyaku-zuki", 25),      
      Golpe.new("Yoko Geri", 15, 10),   
      Golpe.new("Mawashi Geri", 30)
    ]
  end
end

# 2. TaeKwonDo
class TaeKwonDo < ArteMarcial
  def initialize
    super("Tae Kwon Do")
    @golpes = [
      Golpe.new("Dollyo-chagi", 28),
      Golpe.new("Naeryo-chagi", 22, 0, 8), 
      Golpe.new("Yeop-chagi", 26)
    ]
  end
end

# 3. MuayThai
class MuayThai < ArteMarcial
  def initialize
    super("Muay Thai")
    @golpes = [
      Golpe.new("Teep", 20),
      Golpe.new("Sok", 35),
      Golpe.new("Khao", 30, 10)        
    ]
  end
end

# 4. JiuJitsu (Cura 15)
class JiuJitsu < ArteMarcial
  def initialize
    super("Jiu Jitsu")
    @golpes = [
      Golpe.new("Armbar", 18, 15),      
      Golpe.new("Kimura", 22, 12),
      Golpe.new("Triangle", 25)
    ]
  end
end

# 5. Boxeo Chino (Kung Fu en la espe)
class BoxeoChino < ArteMarcial
  def initialize
    super("Boxeo Chino")
    @golpes = [
      Golpe.new("Garra de Tigre", 27),
      Golpe.new("Puño del Dragón", 32, 0, 10),
      Golpe.new("Palma de Fénix", 24, 8)
    ]
  end
end

# 6. Capoeira
class Capoeira < ArteMarcial
  def initialize
    super("Capoeira")
    @golpes = [
      Golpe.new("Martelo", 23),
      Golpe.new("Meia-lua", 26, 6),
      Golpe.new("Armada", 29)
    ]
  end
end

# 7. KravMaga
class KravMaga < ArteMarcial
  def initialize
    super("Krav Maga")
    @golpes = [
      Golpe.new("Golpe directo", 30, 0, 5), 
      Golpe.new("Codazo", 28),
      Golpe.new("Rodillazo", 35)
    ]
  end
end

# 8. Judo
class Judo < ArteMarcial
  def initialize
    super("Judo")
    @golpes = [
      Golpe.new("Ippon Seoi Nage", 20, 10),
      Golpe.new("Osoto Gari", 25),
      Golpe.new("Uchi Mata", 22, 8)
    ]
  end
end

# 9. WingChun: Pei tsu aumenta la vida en 10 y reduce en 5 más al enemigo
class WingChun < ArteMarcial
  def initialize
    super("Wing Chun")
    @golpes = [
      Golpe.new("Chain Punch", 15, 0, 12),
      Golpe.new("Pak Sao", 18, 7),
      Golpe.new("Biu Jee (Pei Tsu)", 28, 10, 5) 
    ]
  end
end

# 10. Sambo
class Sambo < ArteMarcial
  def initialize
    super("Sambo")
    @golpes = [
      Golpe.new("Harai Goshi", 24),
      Golpe.new("Leg Lock", 21, 0, 9), 
      Golpe.new("Suplex", 33)
    ]
  end
end