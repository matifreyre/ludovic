extends "res://addons/gut/test.gd"

var Player = preload('res://Player.gd')
var player
const VIEWPORT_SIZE = Vector2(100,100)
const CELL_SIZE = Vector2(10,10)
const ORIGIN = Vector2(0,0)
	
func get_next_position(direction):
	var next_coordinates = player.get_next_coordinates(direction)
	return player.get_position_for(next_coordinates)

func before_each():
	player = Player.new()
	player.max_column = 9
	player.max_row = 9
	player.cell_size = CELL_SIZE
	player.coordinates = Vector2.ZERO
	
func test_player_starts_on_upper_left_corner():
	assert_eq(ORIGIN, player.get_current_position())
	
func test_players_next_position_down_from_origin():
	var next_position = self.get_next_position(Vector2.DOWN)
	assert_eq(next_position.x, 0)
	assert_eq(next_position.y, CELL_SIZE.y) 
 
func test_players_next_position_right_from_origin():
	var next_position = self.get_next_position(Vector2.RIGHT)
	assert_eq(next_position.x, CELL_SIZE.x)
	assert_eq(next_position.y, 0)
	
func test_players_next_position_left_from_origin_is_origin():
	var next_position = self.get_next_position(Vector2.LEFT)
	assert_eq(next_position, ORIGIN)
	
func test_players_next_position_up_from_origin_is_origin():
	var next_position = self.get_next_position(Vector2.UP)
	assert_eq(next_position, ORIGIN)
	
func test_players_next_position_left_when_not_in_origin():
	player.set_coordinates(Vector2(2,2))
	var next_position = self.get_next_position(Vector2.LEFT)
	assert_eq(next_position.x, 20 - CELL_SIZE.x)
	assert_eq(next_position.y, 20)
	
func test_players_next_position_up_when_not_in_origin():
	player.set_coordinates(Vector2(2,2))
	var next_position = self.get_next_position(Vector2.UP)
	assert_eq(next_position.x, 20)
	assert_eq(next_position.y, 20 - CELL_SIZE.y)

func test_players_next_position_right_when_on_rightmost_cell():
	player.set_coordinates(Vector2(player.max_column, player.max_row))
	var next_position = self.get_next_position(Vector2.RIGHT)
	assert_eq(next_position, VIEWPORT_SIZE - CELL_SIZE)
	
func test_players_next_position_down_when_on_lowest_cell():
	player.set_coordinates(Vector2(player.max_column, player.max_row))
	var next_position = self.get_next_position(Vector2.DOWN)
	assert_eq(next_position, VIEWPORT_SIZE - CELL_SIZE)
	
	