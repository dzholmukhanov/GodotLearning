extends CanvasLayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _ready():
	Game.connect("won", self, "_on_won")

# Called when the node enters the scene tree for the first time.
func _process(delta):
	$BulletsImg/BulletsLbl.text = String(Game.bullets_cnt)
	$EnemiesImg/EnemiesLbl.text = String(Game.enemies_cnt)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_won():
	$BulletsImg.visible = false
	$EnemiesImg.visible = false