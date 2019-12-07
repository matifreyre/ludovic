extends Node2D

class_name Character


signal end_turn
signal character_moved
signal hit(Character)
signal character_dropped

enum { EMPTY = -1, PLAYER, ENEMY, OBSTACLE}

export(String, "Pato Pochoclero", "Payamédico") var character_name
export(int, 9) var initial_column = 0
export(int, 7) var initial_row = 0
export(float, 0, 1, 0.1) var transition_time = 0.5
export(int, 0, 3) var movement_reach = 2
export(Color) var highlight_color = ColorN("Green")
 
onready var board: Board = get_parent()
onready var pivot: Position2D = $Pivot

var is_grabbed: = false
var ghost: AnimatedSprite


"""
Inicialización final del personaje.
"""
func _ready() -> void: 
	# Posición inicial de acuerdo a las coordenadas configuradas
	pivot.position = Vector2(0, board.cell_size.y / 2)
	self.set_position_for(Vector2(initial_column, initial_row))
	set_process(false)


"""
Durante el drag and drop, la imagen se mueve junto con el mouse
"""
func _process(delta: float) -> void:
	if is_grabbed:
		ghost.position = get_global_mouse_position() - board.position - pivot.position


"""
Al liberar el botón del mouse, incluso si no es sobre el área, se debe soltar el jugador.
"""
func _input(event: InputEvent) -> void:
	if is_grabbed and event.is_action_released("left_click"):
		self.perform_drop()


"""
Activación del drag and drop
"""
func _on_Area_input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		self.start_drag()


"""
Detección del overlap de un personaje con otro. 
"""
func _on_Area_area_entered(area: Area2D) -> void:
	emit_signal("hit", self)


"""
Pedido al tablero de resaltar celdas dentro del área de alcance de movimiento.
"""
func request_movement_area_display() -> void:
	board.highlight_cells_within_reach(self.get_coordinates(), self.movement_reach, self.highlight_color)


"""
Ajustar posición a grilla según tamaño de celda.
"""
func snap_position() -> void: 
	# El juego de ir con la posición world -> map -> world hace el snapping	
	var coordinates = board.world_to_map(position + pivot.position)
	self.set_position_for(coordinates)


"""
Ajusta la posición del personaje según coordenadas del mapa.
"""
func set_position_for(coordinates: Vector2) -> void: 
	position = board.map_to_world(coordinates)


"""
Mover el personaje a la celda destino solicitada.
"""
# Puede recibir null y no debe moverse en ese caso
func move(target) -> void:
	if target != null:
		set_process(false)
		self.update_sprite(target)
		self.transition_movement_to(target)

"""
Actualiza los sprites.
"""
func update_sprite(target:Vector2) -> void:
	var current = get_coordinates()
	var t = board.world_to_map(target)
	if (t.y > current.y):
		$Pivot/AnimatedSprite.play("down")
		return
	
	if (t.y < current.y):
		$Pivot/AnimatedSprite.play("up")
		return
	
	if (t.x < current.x):
		$Pivot/AnimatedSprite.play("right")
		return
		
	if (t.x > current.x):
		$Pivot/AnimatedSprite.play("left")
		return

"""
Permite jugar exactamente un turno al personaje activando el process.
"""
func play_turn() -> void:
	set_process(true)
	yield(self, "end_turn")	# espero a que se mueva el personaje para terminar el turno


"""
Animar la transición a la nueva posición, esperando a que se complete y terminando el turno.
"""
func transition_movement_to(new_position: Vector2) -> void:
	$Tween.interpolate_property(self, "position", position, new_position, 
			transition_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_completed")	# espero a terminar la animación
	emit_signal("character_moved")	# aviso que el personaje se movió


"""
Obtener coordenadas a partir de la posición actual.
"""
func get_coordinates() -> Vector2:
	return board.world_to_map(position)


"""
Comienzo de movimiento del personaje por drag and drop.
"""
func start_drag() -> void:
	is_grabbed = true
	self.create_ghost()
	self.request_movement_area_display()


"""
Acciones al soltar al personaje.
"""
func perform_drop() -> void:
	is_grabbed = false
	var target = board.world_to_map(ghost.position + pivot.position)
	if board.is_valid_destination(target):
		self.move_to_target(target)
#		La señal se dispara antes del drop y no se procesa por is_grabbed,
#		por lo tanto, reviso si hay overlaps y disparo de nuevo si es así.
		if not $Pivot/Area.get_overlapping_areas().empty():
			emit_signal("hit", self)
	else:
		self.bump()
	self.destroy_ghost()
	emit_signal("character_dropped")


func move_to_target(target) -> void:
	var path = board.get_path_between_cells(self.get_coordinates(), target)
	for step3D in path:
		var step2D = Vector2(step3D.x, step3D.y)
		self.move(board.map_to_world(step2D))
		yield(self, "character_moved")
	emit_signal("end_turn")


"""
Crear una imagen fantasma para arrastrar
"""
func create_ghost() -> void:
	ghost = AnimatedSprite.new()
	ghost.frames = $Pivot/AnimatedSprite.frames
	ghost.animation = $Pivot/AnimatedSprite.animation
	ghost.frame = $Pivot/AnimatedSprite.frame
	ghost.position = position
	ghost.modulate.a = 0.5
	get_parent().add_child(ghost)


"""
Destruir la imagen fantasma.
"""
func destroy_ghost() -> void:
	ghost.queue_free()
#	TODO: Acá agregar algún efecto


"""
Por defecto, no hace nada. Redefinir en subclases.
"""
func bump() -> void:
	pass