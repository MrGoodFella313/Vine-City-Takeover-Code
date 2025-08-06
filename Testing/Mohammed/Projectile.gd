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
@export var vine_tilemap_path: NodePath

var vine_tilemap: TileMapLayer

func _ready():
	gravity_scale = 0
	vine_tilemap = get_node_or_null(vine_tilemap_path)
	add_to_group("Projectile")
	body_entered.connect(_on_body_entered)

func _physics_process(delta):
	linear_velocity = direction.normalized() * move_speed

func _on_body_entered(body: Node) -> void:
	if body == vine_tilemap:
		var local_pos = vine_tilemap.to_local(global_position)
		var tile_coords = vine_tilemap.local_to_map(local_pos)
		vine_tilemap.erase_cell(tile_coords)
		queue_free()
		
