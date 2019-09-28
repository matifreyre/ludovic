extends Node2D

var is_grabbed = false
onready var POSITION_ADJUSTMENT = -$PlayerSprite.get_rect().size

signal released

func _ready():
	set_process(true)

func _process(delta):
	if is_grabbed:
		self.set_global_position(get_global_mouse_position() + POSITION_ADJUSTMENT)

func _on_PlayerArea_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("left_click"):
		is_grabbed = true
	if event.is_action_released("left_click"):
		is_grabbed = false
		emit_signal("released")

func _on_Player_released():
	self.set_global_position(position.snapped(POSITION_ADJUSTMENT*2))
