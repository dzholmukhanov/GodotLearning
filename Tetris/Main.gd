extends Node2D

var game = TetrisLogic.new()
var block_side = 48
var block_inset = 3

func _ready():
	$Timer.start()
	$HUD.on_game_menu()
	game.connect("score_changed", self, "on_score_changed")

func _draw():
	for i in range(game.grid_height):
		for j in range(game.grid_width):
			_draw_cell(i, j, game.grid[i][j])
			
	if (game.active_block == null): return
	
	var block_coords = game.active_block.get_occupied_coords()
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
	
func on_score_changed():
	$HUD.on_game_score_changed(game.score)
	$HUD.show_message("ASDASJHDASJHDK")

func _process_controls():
	if $ControlTimer.is_stopped():
		if game.game_state == GameStates.PLAY:
			if Input.is_action_pressed("ui_right"):
				game.move_right()
			if Input.is_action_pressed("ui_left"):
				game.move_left()
			if Input.is_action_pressed("ui_down"):
				game.move_down()
			if Input.is_action_pressed("ui_select"):
				game.turn()
		elif game.game_state == GameStates.MENU:
			if Input.is_action_pressed("ui_accept"):
				game.start_game()
				$HUD.on_game_started()
			
		$ControlTimer.start()
		
func _on_Timer_timeout():
	if game.game_state == GameStates.PLAY:
		game.process_step()