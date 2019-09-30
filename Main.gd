extends Node2D

# warning-ignore:unused_class_variable
export(int, 2, 8) var columns : int = 8
# warning-ignore:unused_class_variable
export(int, 2, 5) var rows : int = 5 

func _ready():
	var characters = [$Player, $Enemy] 
	$TurnQueue.play(characters) 