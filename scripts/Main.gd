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
	var new_cell_size := self.get_new_cell_size()
	var change_ratio :  = self.get_change_ratio(cell_size, new_cell_size)
	cell_size = new_cell_size
	for character in characters:
		self.set_display_size(character, new_cell_size, change_ratio)


func get_new_cell_size() -> Vector2:
	var viewport_size : = self.get_viewport_rect().size 
	return Vector2( viewport_size.x / columns, viewport_size.y / rows)


func get_change_ratio(old : Vector2, new : Vector2) -> Vector2:
	return Vector2(new.x / old.x, new.y / old.y) 


func set_display_size(character : Character, new_cell_size : Vector2, change_ratio : Vector2):
	character.set_cell_size(new_cell_size)
	var sprite : = character.get_node("Sprite")
	sprite.scale = sprite.scale * change_ratio 
