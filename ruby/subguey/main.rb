require 'tk'

BG_APP        = "#F5F5F7"
BG_PANEL      = "#FFFFFF"
TEXT_PRIMARY  = "#333333"
TEXT_SECONDARY= "#666666"
ACCENT_COLOR  = "#007AFF"
BTN_COLOR     = "#E0E0E0"

FONT_TITLE    = "Helvetica 14 bold"
FONT_NORMAL   = "Helvetica 10" 
FONT_BOLD     = "Helvetica 10 bold"
FONT_COUNTER  = "Helvetica 10 bold" 
BTN_CHAR_FONT = "Helvetica 8 bold" 


# 1. COMPONENTES BASE (IMPLEMENTACIÓN DEL PATRÓN DECORATOR)

# Componente base abstracto
class SandwichComponent
  attr_reader :size 

  def cost
    raise NotImplementedError
  end

  def description
    raise NotImplementedError
  end
end

# Componente Concreto (El Sándwich Base)
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
    "#{@name} de #{(@size == :small) ? '15 cm' : '30 cm'} ($#{@base_price.round(2)})"
  end
end

# Decorador Base
class IngredientDecorator < SandwichComponent
  def initialize(sandwich_component)
    @sandwich = sandwich_component
  end

  def size
    @sandwich.size
  end
  
  def cost
    @sandwich.cost
  end

  def description
    @sandwich.description
  end
end

# Decorador Concreto (Extra)
class ExtraIngredient < IngredientDecorator
  def initialize(sandwich, name, price_small, price_large)
    super(sandwich)
    @name = name
    @price = (@sandwich.size == :small) ? price_small : price_large
  end

  def cost
    @sandwich.cost + @price
  end

  def description
    super + " + #{@name} ($#{@price.round(2)})"
  end
end



# INTERFAZ GRÁFICA (CLIENTE)


class App
  def initialize
    @root = TkRoot.new { 
      title "SUBGÜEY"
      background BG_APP 
      geometry "500x700" # Ventana
      resizable true, true
      TkOption.add('*background', BG_APP)
      TkOption.add('*foreground', TEXT_PRIMARY)
      TkOption.add('*Entry.background', "#FFFFFF")
      TkOption.add('*Tf.background', BG_PANEL)
      TkOption.add('*Tf.foreground', TEXT_PRIMARY)
      TkOption.add('*Text.background', "#F9F9F9") 
    }
    
    @proteins = {
      "Pavo" => [12, 18], "Italiano" => [9, 16], "Beef" => [10, 16],
      "Veggie" => [8, 14], "Atún" => [11, 17], "Pollo" => [12, 18]
    }
    @extras_data = {
      "Aguacate" => [1.5, 2.5], "Doble Proteína" => [4.5, 8],
      "Hongos" => [0.85, 1.45], "Refresco" => [1, 1],
      "Sopa" => [4.2, 4.2], "Postre" => [3.5, 3.5]
    }
    
    @selected_size = TkVariable.new("small")
    @selected_protein = TkVariable.new("Pavo")
    @extras_vars = {} 
    @total_accumulated = 0.0

    setup_ui
  end

  def setup_ui
    # Encabezado
    header = TkFrame.new(@root) { background ACCENT_COLOR; height 60 }.pack(fill: 'x')
    TkLabel.new(header, text: "SUBGÜEY POS", font: "Helvetica 18 bold", background: ACCENT_COLOR, foreground: "#FFFFFF").pack(pady: 15)

    # Contenedor Principal
    main_container = TkFrame.new(@root) { background BG_APP }.pack(padx: 20, pady: 20, fill: 'both', expand: true)

    # Tarjeta de Selección (tamaño y proteína)
    card_main = TkFrame.new(main_container) { background BG_PANEL; borderwidth 1; relief 'flat' }.pack(fill: 'x', pady: 5)
    
    row1 = TkFrame.new(card_main) { background BG_PANEL }.pack(fill: 'x', padx: 15, pady: 10)
    TkLabel.new(row1, text: "Tamaño:", font: FONT_BOLD, background: BG_PANEL, width: 10, anchor: 'w').pack(side: 'left')
    TkRadioButton.new(row1, text: "15 cm", variable: @selected_size, value: "small", background: BG_PANEL, font: FONT_NORMAL).pack(side: 'left', padx: 10)
    TkRadioButton.new(row1, text: "30 cm", variable: @selected_size, value: "large", background: BG_PANEL, font: FONT_NORMAL).pack(side: 'left')

    row2 = TkFrame.new(card_main) { background BG_PANEL }.pack(fill: 'x', padx: 15, pady: 10)
    TkLabel.new(row2, text: "Proteína:", font: FONT_BOLD, background: BG_PANEL, width: 10, anchor: 'w').pack(side: 'left')
    TkCombobox.new(row2, values: @proteins.keys, textvariable: @selected_protein, state: 'readonly', font: FONT_NORMAL, width: 20).pack(side: 'left', padx: 10)

    # Extras
    TkLabel.new(main_container, text: "ADICIONALES (0 a N)", font: "Helvetica 10 bold", foreground: TEXT_SECONDARY, background: BG_APP).pack(anchor: 'w', pady: [15, 5])
    
    extras_grid = TkFrame.new(main_container) { background BG_APP }.pack(fill: 'x')

    @extras_data.keys.each_with_index do |name, index|
      row_index = index / 2 
      col_index = index % 2 
      
      # tarjeta específica
      card = create_custom_counter(extras_grid, name)
      card.grid(row: row_index, column: col_index, padx: 5, pady: 3, sticky: 'ew')
      

      TkGrid.columnconfigure(extras_grid, col_index, weight: 1)
    end

    
    TkButton.new(main_container, text: "AGREGAR A LA ORDEN", command: proc { add_sandwich },
      background: ACCENT_COLOR, foreground: "white", font: FONT_BOLD, relief: 'flat', pady: 5
    ).pack(fill: 'x', pady: [20, 10])

    # LOG Y TOTAL
    info_frame = TkFrame.new(main_container) { background BG_PANEL }.pack(fill: 'both', expand: true)
    
    @log = TkText.new(info_frame, height: 8, relief: 'flat', font: "Consolas 10", background: "#F9F9F9", borderwidth: 0)
    @log.pack(fill: 'both', expand: true, padx: 10, pady: 10)
    
    @total_label = TkLabel.new(main_container, text: "TOTAL: $0.00", font: "Helvetica 16 bold", foreground: ACCENT_COLOR, background: BG_APP)
    @total_label.pack(anchor: 'e', pady: 10)
  end

  # Contenedor personalizado (Extras)
  def create_custom_counter(parent, name)
    var = TkVariable.new(0)
    @extras_vars[name] = var

    card = TkFrame.new(parent) { background BG_PANEL; borderwidth 1; relief 'solid' }

    TkLabel.new(card, text: name, font: FONT_NORMAL, background: BG_PANEL, width: 12, anchor: 'w').pack(side: 'left', padx: 5)

    # Controles (+ / -) a la derecha
    controls = TkFrame.new(card) { background BG_PANEL }.pack(side: 'right', padx: 5, pady: 2)

    # Botón Menos (-)
    TkButton.new(controls, text: " - ", font: BTN_CHAR_FONT, background: BTN_COLOR, relief: 'flat', width: 2, command: proc { 
      val = var.value.to_i
      var.value = val - 1 if val > 0
    }).pack(side: 'left', ipady: 1) 

    # El Número
    TkLabel.new(controls, textvariable: var, font: FONT_COUNTER, width: 2, background: BG_PANEL, anchor: 'center').pack(side: 'left', padx: 3)

    # Botón Más (+)
    TkButton.new(controls, text: " + ", font: BTN_CHAR_FONT, background: BTN_COLOR, relief: 'flat', width: 2, command: proc { 
      var.value = var.value.to_i + 1
    }).pack(side: 'left', ipady: 1) 
    
    return card 
  end

  def add_sandwich
    size_sym = @selected_size.value.to_sym
    prot_name = @selected_protein.value
    p_prices = @proteins[prot_name]
    
    sandwich = BaseSandwich.new(size_sym, prot_name, p_prices[0], p_prices[1])

    @extras_vars.each do |name, var|
      count = var.value.to_i
      if count > 0
        e_prices = @extras_data[name]
        count.times { sandwich = ExtraIngredient.new(sandwich, name, e_prices[0], e_prices[1]) }
      end
      var.value = 0 
    end

    cost = sandwich.cost.round(2)
    @log.insert('end', "NUEVA ORDEN:\n")
    @log.insert('end', "> #{sandwich.description.chomp(", ")}\n")
    @log.insert('end', "PRECIO: $#{cost}\n\n")
    @log.see('end')
    
    @total_accumulated += cost
    @total_label.text = "TOTAL: $#{@total_accumulated.round(2)}"
  end
end

App.new
Tk.mainloop