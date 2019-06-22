extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var mouse_pos

# Called when the node enters the scene tree for the first time.
func _ready():
	Game.restart()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var new_mouse_pos = get_viewport().get_mouse_position()
	if mouse_pos != null:
		$Camera.translate_object_local(Vector3(new_mouse_pos.x - mouse_pos.x, mouse_pos.y - new_mouse_pos.y, 0) * 0.0005)
	mouse_pos = new_mouse_pos


func _on_MusicTimer_timeout():
	Game.play_main_music()
