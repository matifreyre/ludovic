extends Node2D

class_name Character

signal character_moved
signal hit(Character)

export(String, "Pato Pochoclero", "Payamédico") var character_name
export(int, 1, 9) var max_column = 7
export(int, 1, 7) var max_row = 4
export(int, 9) var initial_column = 0
export(int, 7) var initial_row = 0
export(float, 0, 1, 0.1) var transition_time = 0.5

onready var position_adjustment : Vector2 = -$Sprite.get_rect().size
onready var cell_size : Vector2 = $Sprite.get_rect().size * $Sprite.scale setget set_cell_size, get_cell_size
onready var coordinates : = Vector2(initial_column, initial_row) setget set_coordinates, get_coordinates

var has_turn : = false
var is_grabbed : = false


func _ready() -> void:
	# Posición inicial de acuerdo a las coordenadas configuradas
	self.set_global_position(coordinates * cell_size)


func _process(delta : float) -> void:
	# Seguir el movimiento del mouse durante el drag
	# Posición final es top-left, pero durante el drag el cursor lo quiero en el centro
	if is_grabbed:
		self.set_global_position(get_global_mouse_position() + position_adjustment)


# Drag and drop
func _on_Area_input_event(viewport : Viewport, event : InputEvent, shape_idx : int) -> void:
	if event.is_action_pressed("left_click"):
		is_grabbed = true
	if event.is_action_released("left_click"):
		is_grabbed = false
		self.snap_position()

 
# Ajustar posición a grilla según tamaño de celda
func snap_position() -> void:
	self.set_global_position(position.snapped(cell_size))
	coordinates = self.clamped_coordinates(position / cell_size)


# Mover exactamente una celda en la dirección correspondiente.
func move(direction : Vector2) -> void:
	has_turn = false	# evita doble movimiento dentro del mismo turno
	coordinates = self.get_next_coordinates(direction)
	self.transition_movement_to(self.get_position_for(coordinates))


func play_turn() -> void:
	has_turn = true		# habilita escuchar el input
	yield(self, "character_moved")	# espero a que se mueva el personaje para terminar el turno


func get_next_coordinates(direction : Vector2) -> Vector2:
	return self.clamped_coordinates(coordinates + direction)


func clamped_coordinates(coords : Vector2) -> Vector2:
	return Vector2(clamp(coords.x, 0, max_column), clamp(coords.y, 0, max_row))


func get_coordinates() -> Vector2:
	return coordinates


func set_coordinates(new_coordinates : Vector2) -> void:
	coordinates = new_coordinates
	position = new_coordinates * cell_size


func get_current_position() -> Vector2:
	return coordinates * cell_size


func get_position_for(coords : Vector2) -> Vector2:  
	return coords * cell_size


func set_cell_size(size : Vector2) -> void:
	cell_size = size


func get_cell_size() -> Vector2:
	return cell_size


# Uso Tween para que la transición no sea instantánea sino contínua
func transition_movement_to(new_position : Vector2) -> void:
	$Tween.interpolate_property(self, "position", position, new_position, 
			transition_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_completed")	# espero a terminar la animación
	emit_signal("character_moved")	# aviso que el personaje se movió


# El personaje se está sobre otro
func _on_Area_area_entered(area : Area2D) -> void:
	emit_signal("hit", self)