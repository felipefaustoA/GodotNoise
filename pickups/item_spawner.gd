extends Node3D

@export_group("Configurações Gerais")
@export var terrain_node : MeshInstance3D
@export var scenes_to_spawn : Array[PackedScene]
@export var amount_to_spawn := 50
@export var spawn_offset_y := 0.5

@export_group("Distribuição Procedural")
@export var distribution_noise : FastNoiseLite 
@export_range(-1.0, 1.0) var spawn_threshold := 0.2 

func _ready() -> void:
	spawn_objects_coherently()

func spawn_objects_coherently() -> void:
	if not terrain_node or scenes_to_spawn.is_empty():
		return

	var half_size = 512.0 / 2.0
	var spawned_count = 0
	var attempts = 0
	
	while spawned_count < amount_to_spawn and attempts < amount_to_spawn * 10:
		attempts += 1
		
		var cand_x = randf_range(-half_size, half_size)
		var cand_z = randf_range(-half_size, half_size)
		
		if distribution_noise:
			var noise_value = distribution_noise.get_noise_2d(cand_x, cand_z)
			
			if noise_value < spawn_threshold:
				continue 
		
		var scene = scenes_to_spawn.pick_random()
		var instance = scene.instantiate()
		add_child(instance)

		var height_y = terrain_node.get_height(cand_x, cand_z) + spawn_offset_y
		instance.global_position = Vector3(cand_x, height_y, cand_z)
		instance.rotate_y(randf_range(0, TAU))
		
		spawned_count += 1
