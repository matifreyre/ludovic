extends Node2D

const DEFAULT_COLUMNS : = 8
const DEFAULT_ROWS : = 5

export(int, 2, 10) var columns : int = DEFAULT_COLUMNS
export(int, 2, 8) var rows : int = DEFAULT_ROWS

onready var characters : Array = [$Player, $Enemy]
onready var cell_size : Vector2 = $Player.cell_size


func setup_board(_columns : int = columns, _rows : int = rows) -> void:
	columns = _columns
	rows = _rows


func _ready() -> void:
	self.adjust_scale_to_board_config()
	for character in characters:
		self.set_limits(character)
	self.initialize_enemy() 
	$TurnQueue.play(characters) 


func initialize_enemy() -> void:
	# Esquina inferior derecha
	$Enemy.set_coordinates(Vector2($Enemy.max_column, $Enemy.max_row))


func set_limits(character : Character) -> void:
	# Los personajes no pueden salir del tablero definido
	character.max_column = columns - 1
	character.max_row = rows - 1


# Se ajusta el tablero configurado al tamaño de la pantalla
func adjust_scale_to_board_config() -> void:
	self.scale = Vector2(DEFAULT_COLUMNS / float(columns), DEFAULT_ROWS / float(rows) ) 


func _on_TurnQueue_we_have_a_winner(character : Character):
	character.raise()	# El ganador queda dibujado por encima del otro
	print(character.MESSAGE)	# y se muestra su mensaje
