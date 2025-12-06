extends Node3D

@export var terrain_node : MeshInstance3D
@export var available_pickups : Array[PackedScene] 
@export var amount_to_spawn := 50

func _ready() -> void:
	spawn_items()

func spawn_items() -> void:
	
	if not terrain_node:
		push_error("Terreno não atribuído!")
		return
	if available_pickups.is_empty():
		push_error("Nenhuma cena de pickup foi adicionada na lista!")
		return

	var half_size = 2560.0 / 2.0 
	
	for i in amount_to_spawn:
		var chosen_scene = available_pickups.pick_random()
		var item = chosen_scene.instantiate()
		add_child(item)
		
		var rand_x = randf_range(-half_size, half_size)
		var rand_z = randf_range(-half_size, half_size)
		var height_y = terrain_node.get_height(rand_x, rand_z)
		
		item.global_position = Vector3(rand_x, height_y, rand_z)
