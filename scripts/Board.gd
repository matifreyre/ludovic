extends TileMap

class_name Board

enum { EMPTY = -1, PLAYER, ENEMY}

var characters: Array
var size: Vector2


"""
Configuración de columnas y filas máximos del tablero
"""
func set_size(columns: int, rows: int) -> void:
	size = Vector2(columns - 1, rows - 1)


func _ready() -> void:
	self.set_character_cells()


func set_character_cells() -> void:
	pass
#	for character in characters:
#		set_cellv(world_to_map(character.position), character.type)


"""
Pedido de nuevas coordenadas.
Devuelve null si las coordenadas solicitadas no están permitidas.
"""
# Valor de retorno no tipado porque necesito poder devolver null.
# character no tipado para evitar referencia cíclica en los scripts
func request_move(character, direction: Vector2):
	var cell_start = character.get_coordinates()
	var cell_target = cell_start + direction
	if self.is_out_of_bounds(cell_target):	# No permitir salirse del tablero
		return
	var cell_target_type = get_cellv(cell_target)
	match cell_target_type:
		EMPTY, PLAYER, ENEMY:	# más adelante cambiar según celda
			return updated_character_position(character, cell_start, cell_target)


"""
Actualizar el estado del tablero cuando haya otros elementos además de los personajes
"""
# character no tipado para evitar referencia cíclica en los scripts
func updated_character_position(character, cell_start: Vector2, cell_target: Vector2) -> Vector2:
#	set_cellv(cell_target, character.type)
#	set_cellv(cell_start, EMPTY)
	return map_to_world(cell_target)


"""
Verificar que las nuevas coordanadas no se salgan del tablero
"""
func is_out_of_bounds(cell: Vector2) -> bool:
	return cell.x < 0 or cell.x > size.x or cell.y < 0 or cell.y > size.y