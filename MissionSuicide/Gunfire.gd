extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$Fire.one_shot = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func emit():
	$Fire.emitting = true
	$Timer.start()

func _on_Timer_timeout():
	queue_free()
