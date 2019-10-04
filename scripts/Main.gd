extends Node2D

export(int, 2, 10) var columns : int = 8
export(int, 2, 8) var rows : int = 5 

onready var characters : Array = [$Player, $Enemy]
onready var cell_size : Vector2 = $Player.cell_size


func setup_board(_columns : int = columns, _rows : int = rows) -> void:
	columns = _columns
	rows = _rows


func _ready() -> void:
	self.adjust_to_board_config()
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


func adjust_to_board_config() -> void:
	self.scale = Vector2( 8 / float(columns), 5 / float(rows) )