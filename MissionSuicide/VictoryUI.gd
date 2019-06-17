extends CanvasLayer

func _ready():
	Game.connect("won", self, "_on_won")
	$ParentControl.visible = false

func _on_won():
	$ParentControl.visible = true
	$AnimationPlayer.play("FadeIn")
	$RestartTimer.start()

func _on_RestartTimer_timeout():
	get_tree().change_scene("IntroLevel.tscn")
