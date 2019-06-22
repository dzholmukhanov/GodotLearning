extends KinematicBody

export (PackedScene) var Bullet
export (PackedScene) var Gunfire

var gravity = -9.8
var velocity = Vector3()
var camera

const SPEED = 15
const ACCELERATION = 5
const DE_ACCELERATION = 7
const CAMERA_RAY_LENGTH = 1000
const ROTATION_SPEED = 10

func _ready():
	camera = $Camera.get_global_transform()
	Game.connect("won", self, "_on_won")

func _process(delta):
	$Hero/AnimationTree.set(
		"parameters/Velocity/blend_amount", 
		1 if (velocity * Vector3(1, 0, 1)).length_squared() > 1 else 0)

func _physics_process(delta):
	if Game.is_paused() or Game.is_playing():
		var dir = Vector3()
		if (Input.is_action_pressed("move_fw")):
	 		dir += -camera.basis.z
		if (Input.is_action_pressed("move_bw")):
			dir += camera.basis.z
		if (Input.is_action_pressed("move_l")):
			dir += -camera.basis.x
		if (Input.is_action_pressed("move_r")):
			dir += camera.basis.x
		if (Input.is_action_just_pressed("shoot")):
			shoot()
		if (Input.is_action_just_pressed("pause")):
			pause()
		if (Input.is_action_just_pressed("win")):
			Game.won()
	
		dir.y = 0
		dir = dir.normalized()
	
		var old_vel = velocity
		old_vel.y = 0
	
		var new_vel = dir * SPEED
	
		var accel = DE_ACCELERATION
		if (dir.dot(old_vel) > 0):
			accel = ACCELERATION
	
		var lerp_vel = old_vel.linear_interpolate(new_vel, accel * delta)
		velocity.x = lerp_vel.x
		velocity.z = lerp_vel.z
		velocity.y += delta * gravity
		velocity = move_and_slide(velocity, Vector3.UP)
		track_mouse(delta)
	
func shoot():
	if Game.shoot() or Game.is_paused():
		var bullet = Bullet.instance()
		bullet.transform = $Hero/Armature/BulletSpawn.get_global_transform()
		bullet.set_scale(Vector3(1, 1, 1))
		bullet.is_player_bullet = true
		get_parent().add_child(bullet)
		
		var fire = Gunfire.instance()
		fire.transform = $Hero/Armature/Gun_Attachment/EmitterSpawn.get_global_transform()
		fire.set_scale(Vector3(1, 1, 1))
		fire.rotate(Vector3.UP, PI)
		get_parent().add_child(fire)
		fire.emit()
		
		$Hero/AnimationTree.set("parameters/Shoot/blend_amount", 1)
		$ShootAnimTimer.start()
	
func pause():
	if Game.is_playing():
		Game.pause()
	elif Game.is_paused():
		Game.resume()

func track_mouse(delta):
	var cam = $Camera
	var mousePos = get_viewport().get_mouse_position()
	var from = cam.project_ray_origin(mousePos)
	var to = from + cam.project_ray_normal(mousePos) * CAMERA_RAY_LENGTH
	var space_state = get_world().direct_space_state
	var hit = space_state.intersect_ray(from, to, [], 1)
	var hitPos = hit.get("position")
	if hitPos != null:
		var meshTrans = $Hero.global_transform
		var scale = $Hero.scale
		hitPos.y = meshTrans.origin.y
		var rotTrans = meshTrans.looking_at(hitPos, Vector3.UP)
		var meshQuat = Quat(meshTrans.basis.orthonormalized())
		var slerpQuat = meshQuat.slerp(rotTrans.basis, delta * ROTATION_SPEED)
		$Hero.global_transform = Transform(
			slerpQuat, 
			meshTrans.origin)
		$Hero.scale = scale
	
func receive_damage():
	Game.lost()
	$Hero/AnimationTree.set("parameters/Death/blend_amount", 1)
	

func _on_ShootAnimTimer_timeout():
	$Hero/AnimationTree.set("parameters/Shoot/blend_amount", 0)

func _on_won():
	$Hero/AnimationTree.set("parameters/Dance/blend_amount", 1)
	var meshTrans = $Hero.global_transform
	var scale = $Hero.scale
	var cameraPos = $Camera.global_transform.origin
	cameraPos.y = meshTrans.origin.y
	var rotTrans = meshTrans.looking_at(cameraPos, Vector3.UP)
	var meshQuat = Quat(meshTrans.basis.orthonormalized())
	var slerpQuat = meshQuat.slerp(rotTrans.basis, 1)
	$Hero.global_transform = Transform(
		slerpQuat, 
		meshTrans.origin)
	$Hero.scale = scale