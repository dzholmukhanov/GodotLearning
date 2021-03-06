extends CanvasLayer

func _ready():
	Game.connect("lost", self, "_on_lost")
	$ParentControl.visible = false

func _on_lost():
	$ParentControl.visible = true
	$AnimationPlayer.play("FadeIn")

func _on_NewGameBtn_pressed():
	get_tree().reload_current_scene()

func _on_QuitBtn_pressed():
	get_tree().quit()
