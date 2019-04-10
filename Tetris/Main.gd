extends Node2D


const Tetromino = preload("res://Tetrimino.gd")

enum TetrominoType { I = 0, J = 1, L = 2, O = 3, S = 4, T = 5, Z = 6 }
enum GameState { MENU, PLAY, LOST }
var grid = []
var grid_width = 10
var grid_height = 15
var block_side = 48
var block_inset = 3
var active_block: Tetromino
var score = 0
var game_state = GameState.MENU

func _ready():
	randomize()
	_start_game()
	$Timer.start()
	$ControlTimer.start()

func _start_game():
	grid = []
	for i in range(grid_height):
		grid.push_back([])
		for j in range(grid_width):
			grid[i].push_back(0)
	_spawn_block()
	game_state = GameState.PLAY

func _end_game():
	game_state = GameState.LOST
	
func _draw():
	for i in range(grid_height):
		for j in range(grid_width):
			_draw_cell(i, j, grid[i][j])
			
	if (active_block == null): return
	
	var block_coords = active_block.get_occupied_coords()
	for i in block_coords.size():
		if block_coords[i][0] >= 0:
			_draw_cell(block_coords[i][0], block_coords[i][1], 1)
	
func _draw_cell(i: int, j: int, occupation: int):
	draw_rect(
		Rect2(Vector2(block_side * j, block_side * i),
	 	Vector2(block_side, block_side)), 
		Color.black,
		true) 
	draw_rect(
		Rect2(
			Vector2(
				block_side * j + block_inset, 
				block_side * i + block_inset),
	 		Vector2(
				block_side - block_inset, 
				block_side - block_inset)), 
		Color.darkgreen if occupation == 0 else Color.white, 
		true) 
	
	
func _process(delta):
	_process_controls()
	update()

func _spawn_block():
	active_block = Tetromino.new(-1, 3, randi() % 7)
	if _does_collide_on_spawn(active_block.get_occupied_coords()):
		active_block = null
		return false
	else:
		return true

func _process_controls():
	if $ControlTimer.is_stopped():
		if game_state == GameState.PLAY:
			if Input.is_action_pressed("ui_right"):
				if _can_block_move(0, 1): active_block.move(0, 1)
			if Input.is_action_pressed("ui_left"):
				if _can_block_move(0, -1): active_block.move(0, -1)
			if Input.is_action_pressed("ui_down"):
				if _can_block_move(1, 0): active_block.move(1, 0)
			if Input.is_action_pressed("ui_select"):
				if _can_block_turn(): active_block.turn()
		elif game_state == GameState.MENU:
			if Input.is_action_just_pressed("ui_accept"):
				_start_game()
			
		$ControlTimer.start()

func _process_step():
	if _can_block_move(1, 0):
		active_block.move(1, 0)
	else:
		var cur_coords = active_block.get_occupied_coords()
		for i in cur_coords.size():
			if cur_coords[i][0] >= 0:
				grid[cur_coords[i][0]][cur_coords[i][1]] = 1
		_check_for_filled_lines()
		var spawned = _spawn_block()
		if not spawned:
			_end_game()
			return

func _can_block_move(di: int, dj: int):
	var next_coords = active_block.get_next_occupied_coords(di, dj)
	for i in next_coords.size():
		if (next_coords[i][0] < 0 || next_coords[i][0] >= grid_height ||
			next_coords[i][1] < 0 || next_coords[i][1] >= grid_width ||
			grid[next_coords[i][0]][next_coords[i][1]] == 1):
			return false
	return true
	
func _can_block_turn():
	var next_coords = active_block.get_next_occupied_coords_after_turn()
	for i in next_coords.size():
		if (next_coords[i][0] < 0 || next_coords[i][0] >= grid_height ||
			next_coords[i][1] < 0 || next_coords[i][1] >= grid_width ||
			grid[next_coords[i][0]][next_coords[i][1]] == 1):
			return false
	return true
	
func _does_collide_on_spawn(coords):
	for i in coords.size():
		if (coords[i][0] >= 0 && grid[coords[i][0]][coords[i][1]] == 1):
			return true
	return false
	
func _check_for_filled_lines():
	var new_grid = []
	for i in range(grid_height - 1, -1, -1):
		if grid[i].min() == 0:
			new_grid.push_front(grid[i])
		else:
			score = score + 1
			
	while new_grid.size() < grid_height:
		new_grid.push_front([])
		for j in range(grid_width):
			new_grid[0].push_back(0)
	grid = new_grid
		
func _on_Timer_timeout():
	if active_block != null:
		_process_step()

func _on_ControlTimer_timeout():
	pass