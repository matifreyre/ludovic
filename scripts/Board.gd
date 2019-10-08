extends TileMap

class_name Board

enum { EMPTY = -1, PLAYER, ENEMY}

var characters: Array
var size: Vector2


func set_size(columns: int, rows: int) -> void:
	size = Vector2(columns - 1, rows - 1)


#func _ready() -> void:
#	self.set_character_cells()
#
#
#func set_character_cells() -> void:
#	for character in characters:
#		set_cellv(world_to_map(character.position), character.type)


func request_move(pawn, direction):
	var cell_start = pawn.get_coordinates()
	var cell_target = cell_start + direction
	if self.is_out_of_bounds(cell_target):	# No permitir salirse del tablero
		return
	var cell_target_type = get_cellv(cell_target)
	match cell_target_type:
		EMPTY, PLAYER, ENEMY:	# más adelante cambiar según celda
			return update_pawn_position(pawn, cell_start, cell_target)


func update_pawn_position(pawn, cell_start, cell_target):
#	set_cellv(cell_target, pawn.type)
#	set_cellv(cell_start, EMPTY)
	return map_to_world(cell_target)


func is_out_of_bounds(cell):
	return cell.x < 0 or cell.x > size.x or cell.y < 0 or cell.y > size.y 