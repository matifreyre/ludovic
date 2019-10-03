extends Character	


class_name Player

 
# Movimiento con teclas
func _physics_process(delta : float) -> void:
	if self.has_turn:
		if Input.is_action_just_pressed("ui_down"):
			self.move(Vector2.DOWN)
		if Input.is_action_just_pressed("ui_up"):
			self.move(Vector2.UP)
		if Input.is_action_just_pressed("ui_right"):
			self.move(Vector2.RIGHT)
		if Input.is_action_just_pressed("ui_left"):
			self.move(Vector2.LEFT)