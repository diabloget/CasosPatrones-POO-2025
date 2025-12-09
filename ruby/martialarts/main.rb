require 'tk'
require_relative 'game_controller'

# PALETA DE COLORES
BG_APP      = "#ECEFF1"  # Gris azulado muy claro (Fondo)
BG_PANEL    = "#FFFFFF"  # Blanco (Tarjetas)
PRIMARY_J1  = "#2196F3"  # Azul Material (J1)
PRIMARY_J2  = "#FF9800"  # Naranja Material (J2)
TXT_DARK    = "#37474F"  # Gris oscuro (Texto)
TXT_LIGHT   = "#FFFFFF"
BTN_DISABLE = "#CFD8DC"  # Gris desactivado

# FUENTES

FONT_H1       = "Helvetica 16 bold"
FONT_H2       = "Helvetica 12 bold"
FONT_SUBTITLE = "Helvetica 12 bold"
FONT_NORMAL   = "Helvetica 10"
FONT_BUTTON   = "Helvetica 10 bold"
FONT_MONO     = "Courier 9"
FONT_BOLD     = "Helvetica 10 bold"

class InterfazJuego
  def initialize
    @juego = GameController.new
    crear_interfaz
  end
  
  def iniciar
    Tk.mainloop
  end

  def crear_interfaz
    @root = TkRoot.new do
      title "MartialArts"
      geometry "1100x750"
      background BG_APP
    end
    TkOption.add('*background', BG_APP)
    TkOption.add('*foreground', TXT_DARK)

    # HEADER (Indicador de Turno) 
    @header_frame = TkFrame.new(@root, background: BG_PANEL, pady: 10).pack(fill: 'x')
    @lbl_turno = TkLabel.new(@header_frame, text: "INICIANDO...", font: FONT_H1, background: BG_PANEL)
    @lbl_turno.pack

    # ÁREA DE JUEGO (Split View) 
    game_area = TkFrame.new(@root).pack(fill: 'both', expand: true, padx: 20, pady: 10)

    # COLUMNA JUGADOR 1 (Izquierda) 
    col_j1 = TkFrame.new(game_area, background: BG_PANEL, relief: 'flat', borderwidth: 1)
    col_j1.pack(side: 'left', fill: 'both', expand: true, padx: [0, 10])

    crear_panel_jugador(col_j1, @juego.jugador1, "JUGADOR 1", PRIMARY_J1, 1)

    # COLUMNA JUGADOR 2 (Derecha) 
    col_j2 = TkFrame.new(game_area, background: BG_PANEL, relief: 'flat', borderwidth: 1)
    col_j2.pack(side: 'right', fill: 'both', expand: true, padx: [10, 0])

    crear_panel_jugador(col_j2, @juego.jugador2, "JUGADOR 2", PRIMARY_J2, 2)

    # BITÁCORA (Abajo) 
    log_frame = TkFrame.new(@root, background: BG_PANEL, pady: 5).pack(fill: 'x', padx: 20, pady: [0, 20])
    TkLabel.new(log_frame, text: "Registro de Combate", font: FONT_H2, background: BG_PANEL, anchor: 'w').pack(fill: 'x', padx: 10)
    
    @txt_log = TkText.new(log_frame, height: 12, font: FONT_MONO, relief: 'flat', background: "#FAFAFA")
    @txt_log.pack(side: 'left', fill: 'both', expand: true, padx: 10, pady: 5)
    
    scroll = TkScrollbar.new(log_frame, command: proc { |*a| @txt_log.yview(*a) })
    scroll.pack(side: 'right', fill: 'y')
    @txt_log.yscrollcommand(proc { |*a| scroll.set(*a) })

    # Botón Reiniciar
    btn_reset = TkButton.new(@root, 
      text: "REINICIAR PARTIDA", 
      font: FONT_H2, 
      bg: "#FF5252", 
      fg: "white", 
      relief: 'flat', 
      command: proc { reiniciar_juego }
    )
    btn_reset.pack(fill: 'x', padx: 20, pady: [0, 10])

    # Variables de referencia para botones (para activar/desactivar)
    @btns_j1 = []
    @btns_j2 = []

    actualizar_estado
  end

  def crear_panel_jugador(parent, jugador, titulo, color_tema, id_jugador)
    # Encabezado Panel
    header = TkFrame.new(parent, bg: color_tema, height: 40).pack(fill: 'x')
    TkLabel.new(header, text: titulo, font: FONT_H2, bg: color_tema, fg: "white").pack(pady: 5)

    # Info Vida
    info_frame = TkFrame.new(parent, bg: BG_PANEL).pack(fill: 'x', pady: 10)
    lbl_vida = TkLabel.new(info_frame, text: "HP: 200 / 200", font: FONT_H1, bg: BG_PANEL, fg: color_tema)
    lbl_vida.pack
    
    # Guardar referencia para actualizar
    if id_jugador == 1
      @lbl_hp_j1 = lbl_vida 
    else
      @lbl_hp_j2 = lbl_vida
    end

    # Lista de Artes
    TkLabel.new(parent, text: "Artes Marciales Asignadas:", font: FONT_NORMAL, bg: BG_PANEL, fg: "#78909C").pack(pady: [10, 5])
    lbl_artes = TkLabel.new(parent, text: "...", font: FONT_NORMAL, bg: BG_PANEL, justify: 'center')
    lbl_artes.pack
    
    if id_jugador == 1
      @lbl_artes_j1 = lbl_artes 
    else
      @lbl_artes_j2 = lbl_artes
    end

    # SECCIÓN DE CONTROLES
    ctrl_frame = TkFrame.new(parent, bg: BG_PANEL).pack(fill: 'both', expand: true, padx: 20, pady: 20)
    TkLabel.new(ctrl_frame, text: "ACCIONES", font: FONT_H2, bg: BG_PANEL).pack(pady: [0, 10])

    if id_jugador == 1
      # Controles J1: Permite eligir Arte Específico
      3.times do |i|
        btn = TkButton.new(ctrl_frame, 
          text: "Usar Arte #{i+1}", 
          font: FONT_NORMAL, 
          bg: color_tema, 
          fg: "white", 
          relief: 'flat', 
          pady: 5,
          command: proc { atacar_j1(i) }
        )
        btn.pack(fill: 'x', pady: 3)
        @btns_j1 ||= []
        @btns_j1 << btn
      end
      
      btn_re = TkButton.new(ctrl_frame, 
        text: "Reasignar Estrategias", 
        font: FONT_NORMAL, 
        bg: "#607D8B", 
        fg: "white", 
        relief: 'flat',
        command: proc { reasignar(1) }
      )
      btn_re.pack(fill: 'x', pady: [15, 0])
      @btns_j1 << btn_re

    else
      # Controles J2: Atacar (Random según la espe)
      btn_atk = TkButton.new(ctrl_frame, 
        text: "¡ATACAR!", 
        font: FONT_H1, 
        bg: color_tema, 
        fg: "white", 
        relief: 'flat', 
        pady: 10,
        command: proc { atacar_j2 }
      )
      btn_atk.pack(fill: 'x', pady: 3)
      @btns_j2 ||= []
      @btns_j2 << btn_atk

      TkLabel.new(ctrl_frame, text: "(Selecciona un arte al azar)", font: "Helvetica 8", bg: BG_PANEL, fg: "#90A4AE").pack

      btn_re = TkButton.new(ctrl_frame, 
        text: "Reasignar Estrategias", 
        font: FONT_NORMAL, 
        bg: "#607D8B", 
        fg: "white", 
        relief: 'flat',
        command: proc { reasignar(2) }
      )
      btn_re.pack(fill: 'x', pady: [15, 0])
      @btns_j2 << btn_re
    end
  end

  # Actualizacion de estados

  def actualizar_estado
    # Actualizar textos
    @lbl_hp_j1.text = "HP: #{@juego.jugador1.vida}"
    @lbl_hp_j1.configure(foreground: color_vida(@juego.jugador1.vida))
    
    @lbl_hp_j2.text = "HP: #{@juego.jugador2.vida}"
    @lbl_hp_j2.configure(foreground: color_vida(@juego.jugador2.vida))

    txt_a1 = @juego.jugador1.artes_marciales.map { |a| "• #{a.nombre}" }.join("\n")
    @lbl_artes_j1.text = txt_a1
    
    txt_a2 = @juego.jugador2.artes_marciales.map { |a| "• #{a.nombre}" }.join("\n")
    @lbl_artes_j2.text = txt_a2

    # Log
    @txt_log.delete('1.0', 'end')
    @txt_log.insert('end', @juego.bitacora.join("\n"))
    @txt_log.see('end')

    # Gestión de Turnos (Habilitar/Deshabilitar botones)
    turno = @juego.turno_actual
    fin = !@juego.juego_activo?

    # Header visual
    if fin
      ganador = @juego.verificar_ganador
      @lbl_turno.text = "COMBATE FINALIZADO - #{ganador}"
      @lbl_turno.configure(fg: "#D32F2F")
      toggle_buttons(@btns_j1, false)
      toggle_buttons(@btns_j2, false)
    elsif turno == 1
      @lbl_turno.text = "TURNO: JUGADOR 1"
      @lbl_turno.configure(fg: PRIMARY_J1)
      toggle_buttons(@btns_j1, true, PRIMARY_J1)
      toggle_buttons(@btns_j2, false)
    else
      @lbl_turno.text = "TURNO: JUGADOR 2"
      @lbl_turno.configure(fg: PRIMARY_J2)
      toggle_buttons(@btns_j1, false)
      toggle_buttons(@btns_j2, true, PRIMARY_J2)
    end
  end

  def toggle_buttons(btn_array, enable, original_color = "#ccc")
    return unless btn_array
    state = enable ? 'normal' : 'disabled'
    bg_color = enable ? original_color : BTN_DISABLE
    
    btn_array.each do |btn|
      btn.state(state)
      btn.configure(bg: bg_color)
      # Reasignar buttons son gris oscuro siempre si están activos
      if btn.text.include?("Reasignar") && enable
         btn.configure(bg: "#607D8B")
      end
    end
  end

  def color_vida(hp)
    return "#D32F2F" if hp < 50
    return "#FBC02D" if hp < 100
    "#388E3C"
  end

  # Acciones Especificas

  def atacar_j1(idx)
    @juego.ataque_jugador1(idx)
    actualizar_estado
    check_winner
  end

  def atacar_j2
    @juego.ataque_jugador2
    actualizar_estado
    check_winner
  end

  def reasignar(id)
    target = (id == 1) ? @juego.jugador1 : @juego.jugador2
    # Solo permitir reasignar en tu turno (no indica esto en la espe, pero tiene sentido)
    if @juego.turno_actual == id
        @juego.reasignar_artes(target)
        @juego.bitacora << "-: Jugador #{id} ha cambiado sus artes marciales."
        actualizar_estado
    end
  end

  def reiniciar_juego
    @juego.reiniciar
    actualizar_estado
  end

  def check_winner
    msg = @juego.verificar_ganador
    if msg
      Tk.messageBox(type: 'ok', icon: 'info', title: 'Fin del Combate', message: msg)
    end
  end
end

InterfazJuego.new.iniciar