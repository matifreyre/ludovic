extends "res://addons/gut/test.gd"

var player_scene : = preload('res://scenes/characters/Player.tscn')
var player : Node

func before_each() -> void:
	player = player_scene.instance()
	self.add_child(player)


""" Tests """


func test_cell_size_is_squared() -> void:
	assert_eq(player.cell_size.x, player.cell_size.y)
	assert_gt(player.cell_size.abs(), Vector2(0,0))