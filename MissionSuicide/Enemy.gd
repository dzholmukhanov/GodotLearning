extends KinematicBody

export (PackedScene) var Bullet
export (PackedScene) var Gunfire

var gravity = -9.8
var velocity = Vector3()
var on_screen = false
var player

const ROTATION_SPEED = 5

func _ready():
	rand_seed(1)
	player = get_tree().get_root().find_node("Player", true, false)
	$ProcessTimer.start(rand_range(0.05, 1))
	

func _process(delta):
	if Game.is_playing() and on_screen:
		var meshTrans = $Mesh.global_transform
		var scale = $Mesh.scale
		var plrPos = player.transform.origin
		plrPos.y = meshTrans.origin.y
		var rotTrans = meshTrans.looking_at(plrPos, Vector3.UP)
		var meshQuat = Quat(meshTrans.basis)
		var slerpQuat = meshQuat.slerp(rotTrans.basis, delta * ROTATION_SPEED)
		$Mesh.global_transform = Transform(
			slerpQuat, 
			meshTrans.origin)
		$Mesh.scale = scale

func _on_ProcessTimer_timeout():
	if Game.is_playing() and on_screen:
		shoot()

func _physics_process(delta):
	velocity.y += delta * gravity
	velocity = move_and_slide(velocity, Vector3.UP)

func shoot():
	var bullet = Bullet.instance()
	bullet.transform = $Mesh/BulletSpawn.get_global_transform()
	bullet.set_scale(Vector3(1, 1, 1))
	bullet.is_player_bullet = false
	get_parent().add_child(bullet)
	
	var fire = Gunfire.instance()
	fire.transform = $Mesh/PistolMesh/EmitterSpawn.get_global_transform()
	fire.set_scale(Vector3(1, 1, 1))
	get_parent().add_child(fire)
	fire.emit()
	
func _on_VisibilityNotifier_screen_entered():
	$ReactionTimer.start()

func _on_VisibilityNotifier_screen_exited():
	$ReactionTimer.stop()
	on_screen = false

func receive_damage():
	Game.enemy_died()
	queue_free()

func _on_ReactionTimer_timeout():
	on_screen = true
