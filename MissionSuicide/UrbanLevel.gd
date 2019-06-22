extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var hue

const HUE_SPEED = 0.2

# Called when the node enters the scene tree for the first time.
func _ready():
	Game.start()
	hue = $WorldEnvironment.environment.ambient_light_color.h

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Game.is_won():
		var color = $WorldEnvironment.environment.ambient_light_color
		hue = hue + HUE_SPEED * delta
		if hue > 1:
			hue = 0
		$WorldEnvironment.environment.ambient_light_color = Color.from_hsv(hue, 2, color.v, color.a)
