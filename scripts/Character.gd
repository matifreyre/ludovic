extends Node2D

class_name Character


signal character_moved
signal hit(Character)

enum { EMPTY = -1, PLAYER, ENEMY, OBSTACLE}

export(String, "Pato Pochoclero", "Payamédico") var character_name
export(int, 9) var initial_column = 0
export(int, 7) var initial_row = 0
export(float, 0, 1, 0.1) var transition_time = 0.5
 
onready var board: Board = get_parent()
onready var pivot: Position2D = $Pivot

var is_grabbed: = false


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
func _process(delta : float) -> void:
	if is_grabbed:
		position = get_global_mouse_position() - board.position - pivot.position



"""
Al liberar el mouse, incluso si no es sobre el área, se debe soltar el jugador.
"""
func _input(event: InputEvent) -> void:
	if is_grabbed and event.is_action_released("left_click"):
		is_grabbed = false
		self.snap_position() 



"""
Activación y desactivación del drag and drop
"""
func _on_Area_input_event(viewport : Viewport, event : InputEvent, shape_idx : int) -> void:
	if event.is_action_pressed("left_click"):
		is_grabbed = true


 
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
		self.transition_movement_to(target)


"""
Permite jugar exactamente un turno al personaje activando el process.
"""
func play_turn() -> void:
	set_process(true)
	yield(self, "character_moved")	# espero a que se mueva el personaje para terminar el turno


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
Detección del overlap de un personaje con otro. 
"""
func _on_Area_area_entered(area: Area2D) -> void:
	emit_signal("hit", self)


"""
Obtener coordenadas a partir de la posición actual.
"""
func get_coordinates() -> Vector2:
	var coordinates = board.world_to_map(position)
	return coordinates