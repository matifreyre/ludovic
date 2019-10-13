extends "res://addons/gut/test.gd"

var Main: PackedScene = preload("res://scenes/Main.tscn")
var main: Node = Main.instance()
var Player: = preload("res://scenes/characters/Player.tscn")
var player: Player
var test_player: Player


func before_each() -> void:
	self.add_child(main) 
	test_player = partial_double(Player).instance()
	replace_node(main, "Characters/Player", test_player)
	test_player.board = main.get_node("RealBoard")
	

""" Tests """


#func test_player_moves_on_user_input() -> void:
#	var ev = InputEventAction.new()
#	ev.action = "ui_down"
#	ev.pressed = true
#	Input.parse_input_event(ev)
#	simulate(test_player, 1, 1)
#	yield(yield_to(test_player, 'character_moved', 1), YIELD)
#	assert_called(test_player, 'move')
