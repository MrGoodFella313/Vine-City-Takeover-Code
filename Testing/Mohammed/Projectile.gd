'''extends RigidBody2D

@export var move_speed := 1000.0
@export var direction := Vector2(0,0)

func _ready():
	gravity_scale = 0
	get_tree().create_timer(2.0).timeout.connect(queue_free)


func _physics_process(delta):
	var linear_velocity = direction.normalized() * move_speed
	#print(linear_velocity)
	apply_force(linear_velocity)
	await get_tree().create_timer(2.0).timeout
	queue_free() '''
	
	
extends RigidBody2D

@export var move_speed := 1000.0
@export var direction := Vector2.ZERO
@export var despawn_time: int = 2
#@export var vine_tilemap_path: NodePath

@export var destructible_tile_layer: int = 2
#var vine_tilemap: TileMapLayer

func _ready():
	contact_monitor = true
	max_contacts_reported = 1
	
	gravity_scale = 0
	#vine_tilemap = get_node_or_null(vine_tilemap_path)
	add_to_group("Projectile")
	get_tree().create_timer(despawn_time).timeout.connect(queue_free)

func _physics_process(delta):
	if get_physics_process_delta_time() > 0: # Ensures it only runs on the first frame.
			linear_velocity = direction.normalized() * move_speed
			set_physics_process(false) 

func _on_body_entered(body: Node) -> void:
	if not body is TileMapLayer:
		return

	var tilemap: TileMapLayer = body
	
	# Center our search on the leading edge of the projectile for better accuracy.
	var search_center_global = global_position + linear_velocity.normalized() * 4.0

	# Check a small 5x5 pixel area around the impact point to avoid edge-case misses.
	# A radius of 2 covers a 5x5 grid.
	var search_radius = 2 
	
	for y in range(-search_radius, search_radius + 1):
		for x in range(-search_radius, search_radius + 1):
			
			# Get a point from our search grid in world space
			var check_point_global = search_center_global + Vector2(x, y)
			
			# Convert it to the tilemap's local space
			var check_point_local = tilemap.to_local(check_point_global)
			
			# Convert the local point to map coordinates
			var map_coords = tilemap.local_to_map(check_point_local)
			
			var tile_data = tilemap.get_cell_tile_data(map_coords)
			
			# If we find data at any point in our search grid, process it and stop.
			if tile_data:
				var is_weak_to_fire = tile_data.get_custom_data("weak_fire")
				if is_weak_to_fire  && self.is_in_group("Fire"):
					print("SUCCESS: Hit and destroyed weak tile at ", map_coords)
					tilemap.erase_cell(map_coords)


	
				# Destroy the projectile after any collision with the tilemap.
				queue_free()
				return
	#
	queue_free()
		
