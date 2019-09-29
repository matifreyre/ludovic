extends Node2D

onready var POSITION_ADJUSTMENT : Vector2 = -$PlayerSprite.get_rect().size
onready var CELL_SIZE : Vector2 = POSITION_ADJUSTMENT * 2

var is_grabbed = false
var coordinates = Vector2(0,0)

func _ready():
	# Todavía no sé para qué es esto, viene de ejemplos online pero funciona sin esta línea 
	# set_process(true)
	pass

func _process(delta):
	# Seguir el movimiento del mouse durante el drag
	# Ajuste de posición: posición final es superior-izquierda, pero en el drag está en el centro
	if is_grabbed:
		self.set_global_position(get_global_mouse_position() + POSITION_ADJUSTMENT)

# Movimiento con teclas
func _physics_process(delta):
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
	coordinates -= direction
	var new_position = coordinates * CELL_SIZE
	new_position.x = clamp(new_position.x, 0, get_viewport_rect().size.x + CELL_SIZE.x)
	new_position.y = clamp(new_position.y, 0, get_viewport_rect().size.y + CELL_SIZE.y)
	# Uso Tween para que la transición no sea instantánea sino contínua
	$Tween.interpolate_property(self, "position", position, new_position, 
			0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()