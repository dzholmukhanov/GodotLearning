extends KinematicBody

export (PackedScene) var Bullet
export (PackedScene) var Gunfire

var gravity = -9.8
var velocity = Vector3()
var on_screen = false
var alive = true
var player

const ROTATION_SPEED = 5

func _ready():
	player = get_tree().get_root().find_node("Player", true, false)
	$ProcessTimer.start(rand_range(0.1, 1))
	$Villain.rotate(Vector3.UP, rand_range(-PI, PI))
	

func _process(delta):
	if Game.is_playing() and on_screen and alive:
		var meshTrans = $Villain.global_transform
		var scale = $Villain.scale
		var plrPos = player.transform.origin
		plrPos.y = meshTrans.origin.y
		var rotTrans = meshTrans.looking_at(plrPos, Vector3.UP)
		var meshQuat = Quat(meshTrans.basis.orthonormalized())
		var slerpQuat = meshQuat.slerp(rotTrans.basis, delta * ROTATION_SPEED)
		$Villain.global_transform = Transform(
			slerpQuat, 
			meshTrans.origin)
		$Villain.scale = scale

func _on_ProcessTimer_timeout():
	if Game.is_playing() and on_screen and alive:
		shoot()

func _physics_process(delta):
	if alive:
		velocity.y += delta * gravity
		velocity = move_and_slide(velocity, Vector3.UP)

func shoot():
	var bullet = Bullet.instance()
	bullet.transform = $Villain/BulletSpawn.get_global_transform()
	bullet.set_scale(Vector3(1, 1, 1))
	bullet.is_player_bullet = false
	get_parent().add_child(bullet)
	
	var fire = Gunfire.instance()
	fire.transform = $Villain/Armature/Gun_Attachment/EmitterSpawn.get_global_transform()
	fire.set_scale(Vector3(1, 1, 1))
	fire.rotate(Vector3.UP, PI)
	get_parent().add_child(fire)
	fire.emit()
	
func _on_VisibilityNotifier_screen_entered():
	$ReactionTimer.start()

func _on_VisibilityNotifier_screen_exited():
	$ReactionTimer.stop()
	on_screen = false

func receive_damage():
	if alive:
		Game.enemy_died()
		$Villain/AnimationTree.set("parameters/Death/blend_amount", 1)
		alive = false
		$Collision.disabled = true
		$AudioStreamPlayer.pitch_scale = rand_range(0.75, 1.25)
		$AudioStreamPlayer.play()

func _on_ReactionTimer_timeout():
	on_screen = true
