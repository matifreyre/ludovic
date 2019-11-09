extends TileMap

class_name Board

enum { EMPTY = -1, PLAYER, ENEMY, OBSTACLE}

var characters: Array
var size: Vector2
var aStar: AStar = AStar.new()
var highlight_shapes: Array = []


"""
Eliminar el highlight cuando se suelta al jugador.
"""
func _input(event: InputEvent) -> void:
	if event.is_action_released("left_click"):
		update()


"""
Configuración de columnas y filas máximos del tablero
"""
func set_size(columns: int, rows: int) -> void:
	size = Vector2(columns, rows)
	aStar.clear()
	self.setup_paths()


"""
Para cada celda, configurar un nodo de navegación
"""
func setup_paths() -> void:
	for x in range(size.x):
		for y in range (size.y):
			self.add_point(x,y)
			

"""
Agrega un punto en la ubicación dada y lo conecta con sus vecinos.
"""
func add_point(x: int, y: int) -> void:
	var point_id = get_point_id(x, y)
	var new_point = Vector3(x, y, 0)
	aStar.add_point(point_id, new_point)
	self.connect_with_neighbors(point_id)


"""
Generar un ID único para coordenadas X e Y.
"""
func get_point_id(x: int, y: int) -> int:
	return x * int(size.y) + y


"""
Generar un ID único para el punto en el tablero.
"""
func get_pos_point_id(pos: Vector2) -> int:
	return self.get_point_id(int(pos.x), int(pos.y))


"""
Toma los vecinos existentes (arriba e izquierda) en el aStar y los conecta con el punto actual.
"""
func connect_with_neighbors(point_id: int) -> void:
	for neighbor_id in self.get_neighbor_ids(point_id):
		aStar.connect_points(point_id, neighbor_id)


"""
IDs de vecinos de un ID dado.
"""
func get_neighbor_ids(point_id: int) -> Array:
	var result: = []
	var point_position = aStar.get_point_position(point_id)
	# Vecino izquierdo
	var neighbor_id = self.get_point_id(point_position.x - 1, point_position.y)
	if aStar.has_point(neighbor_id):
		result.append(neighbor_id)
	# Vecino superior
	neighbor_id = self.get_point_id(point_position.x, point_position.y - 1)
	if aStar.has_point(neighbor_id):
		result.append(neighbor_id)
	return result


"""
Conjunto de celdas dentro del aclance desde una posición dada en un máximo de N movimientos.
"""
func get_reachable_cell_ids(coordinates: Vector2, moves: int) -> Array:
	var result: = []
	for x in range(-moves, moves + 1):
		for y in range(-moves, moves + 1):
			var target: = Vector2(coordinates.x + x, coordinates.y + y)
			if not self.is_valid_coordinate(target):
				continue
			var path: = self.get_path_between_cells(coordinates, target)
			var path_moves: = path.size()
			if path_moves > 0 and path_moves <= moves:
				result.append(self.get_pos_point_id(target))
	return result


"""
Conjunto de celdas dentro del aclance desde una posición dada en un máximo de N movimientos.
"""
func is_valid_coordinate(cell: Vector2) -> bool:
	return cell.x in range(0, size.x) and cell.y in range(0, size.y)


"""
Conjunto de celdas alcanzables deben estar.
"""
func is_valid_destination(target: Vector2) -> bool:
	for shape in highlight_shapes:
		if self.world_to_map(shape[0]) == target:
			return true
	return false


"""
Resaltar las celdas dentro de un rango de movimientos.
"""
func highlight_cells_within_reach(coordinates: Vector2, moves: int, color: Color):
	var cell_ids = self.get_reachable_cell_ids(coordinates, moves)
	highlight_shapes.clear()
	for id in cell_ids:
		self.highlight_cell(id, color)
	update()


"""
Resaltar una celda.
"""
func highlight_cell(cell_id: int, color: Color):
	var position3d = aStar.get_point_position(cell_id)
	var position2d = map_to_world(Vector2(position3d.x, position3d.y))
	var transparent_color = color
	transparent_color.a = 0.6       # aplicar factor de transparencia
	highlight_shapes.append([position2d, cell_size.y / 2, transparent_color])      # [shape, color]


"""
Todos los resaltados
"""
func _draw():
	for highlight in highlight_shapes:
		self.draw_circle(highlight[0], highlight[1], highlight[2])      # [position, radius, color]


"""
Obtiene el camino entre 2 celdas.
"""
func get_path_between_cells(cell_start: Vector2, cell_target: Vector2) -> PoolVector3Array:
	var path = aStar.get_point_path(self.get_pos_point_id(cell_start), self.get_pos_point_id(cell_target))
	if path.size() > 0:
		path.remove(0)  # el primer nodo es el propio origen
	return path


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
		OBSTACLE:
			return null


"""
Actualizar el estado del tablero cuando haya otros elementos además de los personajes
"""
# character no tipado para evitar referencia cíclica en los scripts
func updated_character_position(character, cell_start: Vector2, cell_target: Vector2) -> Vector2:
	return map_to_world(cell_target)


"""
Verificar que las nuevas coordanadas no se salgan del tablero
"""
func is_out_of_bounds(cell: Vector2) -> bool:
	return not cell.x in range(0, size.x) or not cell.y in range(0, size.y)


"""
Eliminar casilleros resaltados
"""
func _on_child_character_dropped() -> void:
	highlight_shapes.clear()
	update()
