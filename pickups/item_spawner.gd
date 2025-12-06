extends Node3D

@export_group("Configurações")
@export var terrain_node : MeshInstance3D
@export var scenes_to_spawn : Array[PackedScene] 
@export var amount_to_spawn := 50
@export var spawn_offset_y := 0.5 # 
func _ready() -> void:
	spawn_objects()

func spawn_objects() -> void:
	if not terrain_node or scenes_to_spawn.is_empty():
		return

	var half_size = 512 / 2.0
	
	for i in amount_to_spawn:
		var scene = scenes_to_spawn.pick_random()
		var instance = scene.instantiate()
		add_child(instance) 
		
		var rand_x = randf_range(-half_size, half_size)
		var rand_z = randf_range(-half_size, half_size)
		var height_y = terrain_node.get_height(rand_x, rand_z) + spawn_offset_y
		
		instance.global_position = Vector3(rand_x, height_y, rand_z)
		
		
		instance.rotate_y(randf_range(0, TAU))
