extends Node2D

export(int, 2, 10) var columns : int = 8
export(int, 2, 8) var rows : int = 5 

onready var characters = [$Player, $Enemy] 
onready var cell_size = $Player.cell_size


func setup_board(_columns = columns, _rows = rows):
	columns = _columns
	rows = _rows


func _ready():
	for character in characters:
		self.set_limits(character)  
	self.initialize_enemy() 
	$TurnQueue.play(characters) 


func initialize_enemy():
	# Esquina inferior derecha
	$Enemy.set_coordinates(Vector2($Enemy.max_column, $Enemy.max_row))


func set_limits(character):
	# Los personajes no pueden salir del tablero definido
	character.max_column = columns - 1
	character.max_row = rows - 1