class_name Unit extends CharacterBody3D

@export var dead : bool = false
@export var navigation_agent : NavigationAgent3D

var base_speed : float = 6.0
var current_runing_modifier : float = 1.0
@export var target : Player


func fetch_target():
	var aux_target = null
	for that_player in get_tree().get_nodes_in_group("player"):
		aux_target = that_player
	return aux_target


func _ready():
	await get_tree().create_timer(0.2).timeout 
	target = fetch_target()
	navigation_agent.this_unit = self
