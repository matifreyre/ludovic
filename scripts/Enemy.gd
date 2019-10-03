extends Character


class_name Enemy


var random : = RandomNumberGenerator.new()
enum Direction { UP, DOWN, RIGHT, LEFT } 

 
func _ready():
	random.randomize()


# Movimiento con teclas
func _physics_process(delta : float) -> void:
	if has_turn:
		match self.get_movement():
			Direction.DOWN:
				self.move(Vector2.DOWN)
			Direction.UP:
				self.move(Vector2.UP)
			Direction.RIGHT:
				self.move(Vector2.RIGHT)
			Direction.LEFT:
				self.move(Vector2.LEFT) 


func get_movement() -> int:
	return random.randi_range(0,3)