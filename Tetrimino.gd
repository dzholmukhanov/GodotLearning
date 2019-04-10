enum TetrominoType { I = 0, J = 1, L = 2, O = 3, S = 4, T = 5, Z = 6 }

var i: int
var j: int
var type: int
var turn: int

func _init(var i: int, var j: int, var type: int):
	self.i = i
	self.j = j
	self.type = type
	self.turn = 0
	
func move(di: int, dj: int):
	i = i + di
	j = j + dj

func turn():
	turn = _get_next_turn()
	
func _get_next_turn():
	return (turn + 1) % 4
	
func get_occupied_coords():
	return _get_coords_relative(i, j, turn)
 
func get_next_occupied_coords(di: int, dj: int):
	var ii = i + di
	var jj = j + dj
	return _get_coords_relative(ii, jj, turn)
	
func get_next_occupied_coords_after_turn():
	return _get_coords_relative(i, j, _get_next_turn())

func _get_coords_relative(i: int, j: int, turn: int):
	match type:
		TetrominoType.I:
			match turn:
				0, 2:
					return [[i + 1, j], [i + 1, j + 1], [i + 1, j + 2], [i + 1, j + 3]]
				1, 3:
					return [[i, j + 1], [i + 1, j + 1], [i + 2, j + 1], [i + 3, j + 1]]
		TetrominoType.J:
			match turn:
				0:
					return [[i, j], [i + 1, j], [i + 1, j + 1], [i + 1, j + 2]]
				1:
					return [[i, j], [i, j + 1], [i + 1, j], [i + 2, j]]
				2:
					return [[i, j], [i, j + 1], [i, j + 2], [i + 1, j + 2]]
				3:
					return [[i + 2, j], [i, j + 1], [i + 1, j + 1], [i + 2, j + 1]]
		TetrominoType.L:
			match turn:
				0:
					return [[i + 1, j], [i + 1, j + 1], [i + 1, j + 2], [i, j + 2]]
				1:
					return [[i, j + 1], [i + 1, j + 1], [i + 2, j + 1], [i + 2, j + 2]]
				2:
					return [[i + 1, j], [i + 1, j + 1], [i + 1, j + 2], [i + 2, j]]
				3:
					return [[i, j], [i, j + 1], [i + 1, j + 1], [i + 2, j + 1]]
		TetrominoType.O:
			match turn:
				0, 1, 2, 3:
					return [[i, j], [i, j + 1], [i + 1, j], [i + 1, j + 1]]
		TetrominoType.S:
			match turn:
				0, 2:
					return [[i, j + 1], [i, j + 2], [i + 1, j], [i + 1, j + 1]]
				1, 3:
					return [[i, j], [i + 1, j], [i + 1, j + 1], [i + 2, j + 1]]
		TetrominoType.T:
			match turn:
				0:
					return [[i + 1, j], [i, j + 1], [i + 1, j + 1], [i + 1, j + 2]]
				1:
					return [[i + 2, j + 1], [i, j + 1], [i + 1, j + 1], [i + 1, j + 2]]
				2:
					return [[i + 1, j], [i + 2, j + 1], [i + 1, j + 1], [i + 1, j + 2]]
				3:
					return [[i + 1, j], [i, j + 1], [i + 1, j + 1], [i + 2, j + 1]]
		TetrominoType.Z:
			match turn:
				0, 2:
					return [[i, j], [i, j + 1], [i + 1, j + 1], [i + 1, j + 2]]
				1, 3:
					return [[i, j + 1], [i + 1, j + 1], [i + 1, j], [i + 2, j]]