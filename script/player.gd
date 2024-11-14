class_name Player extends CharacterBody3D

const SPEED = 10.0
const JUMP_VELOCITY = 8.5

@export var  camera : Camera3D
@export var ui : CanvasLayer 
@export var mouse_sensitivity : float = 0.15

var speed_mod : float = 1.0


func _ready():
	#anchors the mouse to the screen
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	# Handle mouse movements.
	if event is InputEventMouseMotion:
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x - event.relative.y * mouse_sensitivity , -45, 45)
		rotation_degrees.y -= event.relative.x * mouse_sensitivity
	
	if Input.is_action_just_pressed("q"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		Global.pause_game(true)
	
	# Resets the current scene/map.
	if Input.is_action_just_pressed("r"):
		Global.reset_map()

	if Input.is_action_just_pressed("shift"):
		if speed_mod == 1.0:
			speed_mod = 2.0
		else:
			speed_mod = 1.0


func _physics_process(delta):
	_handle_noclip(delta)
	
	if noclip: return
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * 3

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY * speed_mod

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("a", "d", "w", "s")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED * speed_mod
		velocity.z = direction.z * SPEED * speed_mod
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * speed_mod)
		velocity.z = move_toward(velocity.z, 0, SPEED * speed_mod)

	move_and_slide()


#___________________________________________________________________________________________________
#____________________________________________ NOCLIP _______________________________________________
var noclip_speed_mult : float = 3.0
var noclip : bool = false
var cam_aligned_wish_dir : Vector3 = Vector3.ZERO

func _handle_noclip(delta) -> bool:
	if Input.is_action_just_pressed("v") and OS.has_feature("debug"):
		noclip = !noclip
		noclip_speed_mult = 3.0

	$CollisionShape.disabled = noclip

	if not noclip:
		return false

	var input_dir := Input.get_vector("a", "d", "w", "s").normalized()
	cam_aligned_wish_dir = camera.global_transform.basis * Vector3(input_dir.x, 0., input_dir.y)

	var speed : float = 10.0 * noclip_speed_mult * speed_mod
	if Input.is_action_pressed("w"):
		speed *= 2.0

	self.velocity = cam_aligned_wish_dir * speed#Vector3.ZERO # GMod style where you can fly w/ noclip
	global_position += self.velocity * delta
	
	return true
#___________________________________________________________________________________________________
