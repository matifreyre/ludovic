extends Node2D

# warning-ignore:unused_class_variable
export(int, 2, 8) var columns : int = 8
# warning-ignore:unused_class_variable
export(int, 2, 5) var rows : int = 5 

onready var characters = [$Player, $Enemy] 

func _ready():
	self.set_limits($Player)
	self.set_limits($Enemy)
	$TurnQueue.play(characters) 
	
func set_limits(character):
	character.max_column = columns - 1
	character.max_row = rows - 1