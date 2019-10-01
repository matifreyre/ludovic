extends "res://addons/gut/test.gd"

var player_scene = preload('res://Player.tscn')
var player

func before_each():
	player = player_scene.instance()
	self.add_child(player)
	
func test_cell_size_is_squared():
	assert_eq(player.cell_size.x, player.cell_size.y)
	assert_gt(player.cell_size.abs(), Vector2(0,0))
