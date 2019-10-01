extends Node2D

signal character_moved

export(String, "Pato Pochoclero", "Payamédico") var character_name
export(int, 2, 10) var max_column = 7
export(int, 2, 10) var max_row = 4
export(int, 7) var initial_column = 0
export(int, 5) var initial_row = 0
export(float, 0, 1, 0.1) var transition_time = 0.5

onready var position_adjustment : Vector2 = -$PlayerSprite.get_rect().size
onready var cell_size : Vector2 = $PlayerSprite.get_rect().size * 2 setget set_cell_size, get_cell_size
onready var coordinates = Vector2(initial_column, initial_row) setget set_coordinates, get_coordinates

var has_turn = false 
var is_grabbed = false


func _ready():
	# Posición inicial de acuerdo a las coordenadas configuradas
	self.set_global_position(coordinates * cell_size)
		

func _process(delta):
	# Seguir el movimiento del mouse durante el drag
	# Posición final es top-left, pero durante el drag el cursor lo quiero en el centro
	if is_grabbed:
		self.set_global_position(get_global_mouse_position() + position_adjustment)


# Movimiento con teclas
func _physics_process(delta):
	if has_turn:
		if Input.is_action_just_pressed("ui_down"):
			self.move(Vector2.DOWN)
		if Input.is_action_just_pressed("ui_up"):
			self.move(Vector2.UP)
		if Input.is_action_just_pressed("ui_right"):
			self.move(Vector2.RIGHT)
		if Input.is_action_just_pressed("ui_left"):
			self.move(Vector2.LEFT)


# Drag and drop
func _on_PlayerArea_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("left_click"):
		is_grabbed = true
	if event.is_action_released("left_click"):
		is_grabbed = false
		self.snap_position()

 
# Ajustar posición a grilla según tamaño de celda
func snap_position():
	self.set_global_position(position.snapped(cell_size))
	coordinates = self.clamped_coordinates(position / cell_size)
	
	
# Mover exactamente una celda en la dirección correspondiente.
func move(direction):
	has_turn = false	# evita doble movimiento dentro del mismo turno
	coordinates = self.get_next_coordinates(direction)
	self.transition_movement_to(self.get_position_for(coordinates))
	
	
func play_turn():
	has_turn = true		# habilita escuchar el input
	yield(self, "character_moved")	# espero a que se mueva el personaje para terminar el turno

	
func get_next_coordinates(direction):
	return self.clamped_coordinates(coordinates + direction)
	

func clamped_coordinates(coords):
	var new_coordinates : Vector2
	new_coordinates.x = clamp(coords.x, 0, max_column)
	new_coordinates.y = clamp(coords.y, 0, max_row)
	return new_coordinates
	
	
func get_coordinates():
	return coordinates


func set_coordinates(new_coordinates):
	coordinates = new_coordinates
	position = new_coordinates * cell_size


func get_current_position():
	return coordinates * cell_size


func get_position_for(coords):  
	return coords * cell_size


func set_cell_size(size): 
	cell_size = size
	
	
func get_cell_size():
	return cell_size
	
	
# Uso Tween para que la transición no sea instantánea sino contínua
func transition_movement_to(new_position):
	$Tween.interpolate_property(self, "position", position, new_position, 
			transition_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_completed")	# espero a terminar la animación
	emit_signal("character_moved")	# aviso que el personaje se movió