extends Node2D

signal character_moved

export var transition_time = 0.5
export var character_name : String

onready var POSITION_ADJUSTMENT : Vector2 = -$PlayerSprite.get_rect().size
onready var CELL_SIZE : Vector2 = $PlayerSprite.get_rect().size * 2
onready var SCREEN_RIGHTMOST_POS : float = get_viewport_rect().size.x - CELL_SIZE.x
onready var SCREEN_BOTTOM_POS : float = get_viewport_rect().size.y - CELL_SIZE.y

var has_turn = false 
var is_grabbed = false
onready var coordinates = position / CELL_SIZE


func _ready():
	# Todavía no sé para qué es esto, viene de ejemplos online pero funciona sin esta línea 
	# set_process(true)
	pass


func _process(delta):
	# Seguir el movimiento del mouse durante el drag
	# Posición final es top-left, pero durante el drag está en el centro
	if is_grabbed:
		self.set_global_position(get_global_mouse_position() + POSITION_ADJUSTMENT)


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
	self.set_global_position(position.snapped(CELL_SIZE))
	coordinates = position / CELL_SIZE
	
	
# Mover en exactamente una celda en la dirección correspondiente.
# TODO Debe haber una mejor forma de acotar el espacio y hacer la transición
func move(direction):
	has_turn = false	# evita doble movimiento dentro del mismo turno
	coordinates += direction
	var new_position = coordinates * CELL_SIZE
	# Acoto la posición
	new_position.x = clamp(new_position.x, 0, SCREEN_RIGHTMOST_POS)
	new_position.y = clamp(new_position.y, 0, SCREEN_BOTTOM_POS)
	coordinates = new_position / CELL_SIZE	# ajusto coordenadas con posición ajustada
	# Uso Tween para que la transición no sea discreta, sino contínua
	$Tween.interpolate_property(self, "position", position, new_position, 
			transition_time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.start()
	yield($Tween, "tween_completed")	# espero a terminar la animación
	emit_signal("character_moved")	# aviso que el personaje se movió
	
	
func play_turn():
	has_turn = true		# habilita escuchar el input
	yield(self, "character_moved")	# espero a que se mueva el personaje para terminar el turno