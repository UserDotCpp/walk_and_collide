extends CharacterBody3D

@export var  camera : Camera3D
@export var mouse_sensitivity : float = 0.15

const SPEED = 10.0
const JUMP_VELOCITY = 4.5

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



func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("a", "d", "w", "s")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
