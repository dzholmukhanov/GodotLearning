extends KinematicBody

export (PackedScene) var Bullet

var gravity = -9.8
var velocity = Vector3()
var on_screen = false
var player

const ROTATION_SPEED = 5

func _ready():
	player = get_tree().get_root().find_node("Player", true, false)

func _process(delta):
	if Game._is_playing() and on_screen:
		var meshTrans = $Mesh.global_transform
		var plrPos = player.transform.origin
		plrPos.y = meshTrans.origin.y
		var rotTrans = meshTrans.looking_at(plrPos, Vector3.UP)
		var meshQuat = Quat(meshTrans.basis)
		var slerpQuat = meshQuat.slerp(rotTrans.basis, delta * ROTATION_SPEED)
		$Mesh.global_transform = Transform(
			slerpQuat, 
			meshTrans.origin)

func _on_ProcessTimer_timeout():
	if Game._is_playing() and on_screen:
		shoot()

func _physics_process(delta):
	velocity.y += delta * gravity
	velocity = move_and_slide(velocity, Vector3.UP)
#
#	if velocity.length() > 0.1:
#		var rot = $Mesh.get_rotation()
#		rot.y = atan2(lerp_vel.x, lerp_vel.z)
#		$Mesh.set_rotation(rot)

func shoot():
	var bullet = Bullet.instance()
	bullet.transform = $Mesh/BulletSpawn.get_global_transform()
	bullet.set_scale(Vector3(1, 1, 1))
	bullet.player = self
	get_parent().add_child(bullet)
	
	
func _on_VisibilityNotifier_screen_entered():
	on_screen = true


func _on_VisibilityNotifier_screen_exited():
	on_screen = false
