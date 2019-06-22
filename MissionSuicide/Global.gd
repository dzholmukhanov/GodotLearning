extends Node

const MENU = 0
const PLAYING = 1
const PAUSED = 2
const WON = 3
const LOST = 4

var state
var enemies_cnt = 0
var bullets_cnt = 0

signal paused
signal resumed
signal lost
signal won

func _ready():
	pass
	
func _process(delta):
	pass
	
func restart():
	state = MENU
	
func start():
	state = PLAYING
	var enemies = get_tree().get_nodes_in_group("Enemies")
	enemies_cnt = enemies.size()
	bullets_cnt = 100
	
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
		play_victory_music()

func enemy_died():
	enemies_cnt -= 1
	if enemies_cnt == 0:
		won()
		
func shoot():
	if bullets_cnt > 0:
		if is_playing():
			bullets_cnt = bullets_cnt - 1
		return true
	return false
	
func play_main_music():
	$VictoryAudioPlayer.stop()
	$MainAudioPlayer.play(0)

func play_victory_music():
	$MainAudioPlayer.stop()
	$VictoryAudioPlayer.play(0)