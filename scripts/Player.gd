extends Character	

class_name Player


signal bump

const MESSAGE : = "You win!"

enum CELL_TYPES { EMPTY = -1, PLAYER, ENEMY }

export(CELL_TYPES) var type = CELL_TYPES.PLAYER

 
"""
Escuchar input de usuario para procesar el turno del jugador.
"""
func _process(delta : float) -> void:
	var input_direction = self.get_input_direction()
	if input_direction:
		var target_position = board.request_move(self, input_direction)
		if target_position != null:
			self.move(target_position)
		else:
			self.bump()


"""
Leer la dirección de input según teclas presionadas.
"""
func get_input_direction() -> Vector2:
	return Vector2(
		int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")),
		int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	)


"""
Acción realizada cuando el movimiento ingresado no es válido.
"""
func bump() -> void:
	emit_signal("bump")