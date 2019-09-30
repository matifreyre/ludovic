extends "res://addons/gut/test.gd"

var Player = preload('res://Player.gd')
var player
const viewport_size = Vector2(100,100)

func before_each():
	player = Player.new()
	player.set_cell_size(Vector2(10,10))
	player.set_position(Vector2(20,20))
	

func test_players_next_position_up():
	var initial_position = player.get_position()
	var next_position = player.get_next_position(Vector2.UP, viewport_size)
	assert_eq(initial_position.x, next_position.x)
	assert_ne(initial_position.y, next_position.y)

func test_players_next_position_down():
	var initial_position = player.get_position()
	var next_position = player.get_next_position(Vector2.DOWN, viewport_size)
	assert_eq(initial_position.x, next_position.x)
	assert_ne(initial_position.y, next_position.y)

func test_players_next_position_left():
	var initial_position = player.get_position()
	var next_position = player.get_next_position(Vector2.LEFT, viewport_size)
	assert_ne(initial_position.x, next_position.x)
	assert_eq(initial_position.y, next_position.y)
	
func test_players_next_position_right():
	var initial_position = player.get_position()
	var next_position = player.get_next_position(Vector2.RIGHT, viewport_size)
	assert_ne(initial_position.x, next_position.x)
	assert_eq(initial_position.y, next_position.y)
