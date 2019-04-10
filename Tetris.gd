#const Tetromino = preload("res://Tetrimino.gd")
#
#enum TetrominoType { I = 0, J = 1, L = 2, O = 3, S = 4, T = 5, Z = 6 }
#var grid = [[]]
#var grid_width = 10
#var grid_height = 15
#var active_block: Tetromino
#
#func _init():
#	randomize()
#	for i in range(grid_height):
#		for j in range(grid_width):
#			grid[i][j] = 0
#	active_block = Tetromino.new(0, 3, randi() % 7)
#
#func _draw():
#