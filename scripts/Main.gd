extends Node2D

export(int, 2, 8) var columns : int = 8
export(int, 2, 5) var rows : int = 5 

onready var characters = [$Player, $Enemy] 

func _ready():
	for character in characters:
		self.set_limits(character)
	$TurnQueue.play(characters) 
	
func set_limits(character):
	character.max_column = columns - 1
	character.max_row = rows - 1