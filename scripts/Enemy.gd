extends Character


class_name Enemy

const MESSAGE : = "You lose!"

enum CELL_TYPES { EMPTY = -1, PLAYER, ENEMY }
export(CELL_TYPES) var type = CELL_TYPES.ENEMY

var random : = RandomNumberGenerator.new()
enum Direction { UP, DOWN, RIGHT, LEFT } 

 
"""
Inicializar el enemigo.
"""
func _init() -> void:
	random.randomize()


"""
Realizar un movimiento automático.
"""
func _process(delta : float) -> void:
	match self.get_movement():
		Direction.DOWN:
			self.validated_move(Vector2.DOWN)
		Direction.UP:
			self.validated_move(Vector2.UP)
		Direction.RIGHT:
			self.validated_move(Vector2.RIGHT)
		Direction.LEFT:
			self.validated_move(Vector2.LEFT) 


"""
Movimiento validado, debe quedar dentro del tablero.
"""
func validated_move(direction: Vector2) -> void:
	var target_cell: Vector2 = board.request_move(self, direction)
	if target_cell != null:
		self.move(target_cell) 


"""
Generar el movimiento automático.
"""
func get_movement() -> int:
	return random.randi_range(0,3)