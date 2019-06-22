extends CanvasLayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	Game.connect("paused", self, "_on_pause")
	Game.connect("resumed", self, "_on_resume")
	$ParentControl.visible = false

func _on_pause():
	$ParentControl.visible = true
	
func _on_resume():
	$ParentControl.visible = false

func _on_ResumeBtn_pressed():
	Game.resume()

func _on_NewGameBtn_pressed():
	get_tree().reload_current_scene()


func _on_QuitBtn_pressed():
	get_tree().quit()
