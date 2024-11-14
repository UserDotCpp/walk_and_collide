extends NavigationAgent3D

@export var this_unit : Unit
var reach_target_counter : float = 1.0
@export var rand_reach_target_counter_goal : float = 1.0
var next_nav_point : Vector3
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	if this_unit.dead: #is_instance_valid(this_unit) or this_unit.dead:
		set_physics_process(false)

func _physics_process(delta):
	if not this_unit.dead :
		reach_target_counter += delta
		_individual_movement_calc(delta)
		if not this_unit.is_on_floor():
			this_unit.velocity.y -= gravity * delta
		#this_unit.move_and_slide()


func _individual_movement_calc(delta):
	if is_instance_valid(this_unit.target) and  not this_unit.dead:
		if reach_target_counter > rand_reach_target_counter_goal:#0.5:
			#self.target_position = (this_unit.target.global_position)
			set_target_position(this_unit.target.global_position)

			reach_target_counter = 0.0

		next_nav_point = self.get_next_path_position()

		this_unit.velocity = (next_nav_point - this_unit.global_transform.origin).normalized() * ( this_unit.base_speed + this_unit.current_runing_modifier)

		if this_unit.transform.origin != next_nav_point:
			this_unit.look_at(next_nav_point,Vector3.UP)
			this_unit.rotation.x = 0
			this_unit.rotation.z = 0


func _on_velocity_computed(safe_velocity):
	this_unit.velocity = this_unit.velocity.move_toward(safe_velocity,0.25)
	if self.is_navigation_finished:
		this_unit.move_and_slide()
