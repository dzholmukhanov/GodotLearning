extends Area

var direction
var velocity
var lifetime
var is_player_bullet

const SPEED = 30
const TIMEOUT = 2

func _ready():
	direction = -transform.basis.z
	velocity = direction * SPEED
	lifetime = 0

func _process(delta):
	if Game.is_playing():
		global_translate(velocity * delta)
		lifetime += delta
	if lifetime > TIMEOUT:
		queue_free()

func _on_Bullet_body_entered(body):
	if Game.is_playing():
		if ((is_player_bullet and not body.is_in_group("Player")) 
		or (not is_player_bullet and not body.is_in_group("Enemies"))):
			if body.is_in_group("Player") or body.is_in_group("Enemies"):
				body.receive_damage()
			queue_free()