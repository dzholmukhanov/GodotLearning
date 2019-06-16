extends Node

const START = 0
const PLAYING = 1
const PAUSED = 2
const WON = 3
const LOST = 4

var state
var enemies_cnt

signal paused
signal resumed
signal lost
signal won

func _ready():
	restart()
	var enemies = get_tree().get_nodes_in_group("Enemies")
	enemies_cnt = enemies.size()
	
func _process(delta):
	print_debug(enemies_cnt)
	
func restart():
	state = PLAYING
	
func is_paused():
	return state == PAUSED
func is_playing():
	return state == PLAYING

func pause():
	if state == PLAYING:
		state = PAUSED
		emit_signal("paused")
		
func resume():
	if state == PAUSED:
		state = PLAYING
		emit_signal("resumed")
		
func lost():
	if state == PLAYING:
		state = LOST
		emit_signal("lost")

func won():
	if state == PLAYING:
		state = WON
		emit_signal("won")

func enemy_died():
	enemies_cnt -= 1
	if enemies_cnt == 0:
		won()