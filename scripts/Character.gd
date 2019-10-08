extends Node2D

class_name Character

signal character_moved
signal hit(Character)

enum { EMPTY = -1, PLAYER, ENEMY}

export(String, "Pato Pochoclero", "Payamédico") var character_name
export(int, 9) var initial_column = 0
export(int, 7) var initial_row = 0
export(float, 0, 1, 0.1) var transition_time = 0.5
 
onready var board: Board = get_node("../../RealBoard")

var is_grabbed: = false


func _ready() -> void: 
	# Posición inicial de acuerdo a las coordenadas configuradas
	$Pivot.position = board.cell_size / 2
	self.set_position_for(Vector2(initial_column, initial_row))
	set_process(false)


func _process(delta : float) -> void:
	if is_grabbed:
		self.set_global_position(get_global_mouse_position() - $Pivot.position)


# Drag and drop
func _on_Area_input_event(viewport : Viewport, event : InputEvent, shape_idx : int) -> void:
	if event.is_action_pressed("left_click"):
		is_grabbed = true
	if event.is_action_released("left_click"):
		is_grabbed = false
		self.snap_position() 

 
# Ajustar posición a grilla según tamaño de celda
func snap_position() -> void:
	self.set_position_for(self.get_coordinates())


func set_position_for(_coordinates) -> void: 
	position = board.map_to_world(_coordinates)


# Mover exactamente una celda en la dirección correspondiente.
func move(target: Vector2) -> void:
	set_process(false)
	self.transition_movement_to(target)


func bump() -> void:
	pass


func play_turn() -> void:
	set_process(true)
	yield(self, "character_moved")	# espero a que se mueva el personaje para terminar el turno


# Uso Tween para que la transición no sea instantánea sino contínua
func transition_movement_to(new_position: Vector2) -> void:
	$Tween.interpolate_property(self, "position", position, new_position, 
			transition_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_completed")	# espero a terminar la animación
	emit_signal("character_moved")	# aviso que el personaje se movió


# El personaje está sobre otro
func _on_Area_area_entered(x) -> void:
	print("hit")
	emit_signal("hit", self)


func get_coordinates() -> Vector2:
	return board.world_to_map(position)