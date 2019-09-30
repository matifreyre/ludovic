extends "res://addons/gut/test.gd"

var Player = preload('res://Player.gd')
var player
const VIEWPORT_SIZE = Vector2(100,100)
const CELL_SIZE = Vector2(-10,-10)
const ORIGIN = Vector2(0,0)

func before_each():
	player = Player.new()
	player.set_cell_size(CELL_SIZE)
	
func test_player_starts_on_upper_left_corner():
	assert_eq(ORIGIN, player.get_position())
	
func test_players_next_position_down_from_origin():
	var next_position = player.get_next_position(Vector2.DOWN, VIEWPORT_SIZE)
	assert_eq(0, next_position.x)
	assert_eq(- CELL_SIZE.y, next_position.y)

func test_players_next_position_right_from_origin():
	var next_position = player.get_next_position(Vector2.RIGHT, VIEWPORT_SIZE)
	assert_eq(- CELL_SIZE.x, next_position.x)
	assert_eq(0, next_position.y)
	
func test_players_next_position_left_from_origin_is_origin():
	var next_position = player.get_next_position(Vector2.LEFT, VIEWPORT_SIZE)
	assert_eq(ORIGIN, next_position)
	
func test_players_next_position_up_from_origin_is_origin():
	var next_position = player.get_next_position(Vector2.UP, VIEWPORT_SIZE)
	assert_eq(ORIGIN, next_position)
	
func test_players_next_position_left_when_not_in_origin():
	player.set_position(Vector2(20,20))
	var next_position = player.get_next_position(Vector2.LEFT, VIEWPORT_SIZE)
	assert_eq(20 + CELL_SIZE.x, next_position.x)
	assert_eq(20, next_position.y)
	
func test_players_next_position_up_when_not_in_origin():
	player.set_position(Vector2(20,20))
	var next_position = player.get_next_position(Vector2.UP, VIEWPORT_SIZE)
	assert_eq(20, next_position.x)
	assert_eq(20 + CELL_SIZE.y, next_position.y)

func test_players_next_position_right_when_on_rightmost_cell():
	player.set_position(VIEWPORT_SIZE)
	var next_position = player.get_next_position(Vector2.RIGHT, VIEWPORT_SIZE)
	assert_eq(VIEWPORT_SIZE + CELL_SIZE, next_position)
	
func test_players_next_position_down_when_on_lowest_cell():
	player.set_position(VIEWPORT_SIZE)
	var next_position = player.get_next_position(Vector2.DOWN, VIEWPORT_SIZE)
	assert_eq(VIEWPORT_SIZE + CELL_SIZE, next_position)