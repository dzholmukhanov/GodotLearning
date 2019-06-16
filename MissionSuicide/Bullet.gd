extends Area

var direction
var velocity
var lifetime
var player

const SPEED = 30
const TIMEOUT = 2

func _ready():
	direction = -transform.basis.z
	velocity = direction * SPEED
	lifetime = 0

func _process(delta):
	if Game._is_playing():
		global_translate(velocity * delta)
		lifetime += delta
	if lifetime > TIMEOUT:
		queue_free()

func _on_Bullet_body_entered(body):
	if body != player:
		queue_free()