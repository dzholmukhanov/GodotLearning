extends Node

const START = 0
const PLAYING = 1
const PAUSED = 2
const WON = 3
const LOST = 4

var state

func _ready():
	state = PLAYING

func _is_paused():
	return state == PAUSED
func _is_playing():
	return state == PLAYING