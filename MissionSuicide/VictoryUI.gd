extends CanvasLayer

var hue

const HUE_SPEED = 1

func _ready():
	Game.connect("won", self, "_on_won")
	$ParentControl.visible = false
	hue = $ParentControl/VictoryLbl.get_color("font_color").h
	
func _process(delta):
		var color = $ParentControl/VictoryLbl.get_color("font_color")
		hue = hue + HUE_SPEED * delta
		if hue > 1:
			hue = 0
		$ParentControl/VictoryLbl.add_color_override(
			"font_color", Color.from_hsv(hue, color.s, color.v, color.a))

func _on_won():
	$ParentControl.visible = true
	$AnimationPlayer.play("FadeIn")
	$RestartTimer.start()

func _on_RestartTimer_timeout():
	get_tree().change_scene("MainMenuLevel.tscn")
