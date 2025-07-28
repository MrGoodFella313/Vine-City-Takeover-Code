extends Control


@export var full_heart_texture: Texture2D
@export var half_heart_texture: Texture2D
@export var empty_heart_texture: Texture2D

@export var hearts_container: HBoxContainer

@export var Monty: Node

func _ready():
	#Monty = get_node_or_null("/root/Monty")
	
	if Monty:
		generate_hearts(Monty.max_health)
		print("Max | ", Monty.max_health)
		Monty.health_changed.connect(update_hearts)
		update_hearts(Monty.current_health)
		print("Update | ", Monty.current_health)
	else:
		print("HealthUI Error: Player node not found. Ensure the node path is correct.")

func generate_hearts(max_health: int):
	for child in hearts_container.get_children():
		child.queue_free()
		
	var num_hearts = ceil(max_health / 2.0)

	for i in range(num_hearts):
		var heart = TextureRect.new()
		heart.texture = empty_heart_texture # Start with an empty heart texture.
		heart.custom_minimum_size = Vector2(128,128)
		heart.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		heart.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		hearts_container.add_child(heart)

func update_hearts(health: int):
	# Get all the heart TextureRect nodes from the container.
	var hearts = hearts_container.get_children()
	
	# Loop through each heart UI element. 'i' will be the index (0 to 4).
	for i in range(hearts.size()):
		# Each heart represents 2 health points.
		var heart_health_threshold = (i + 1) * 2
		
		if health >= heart_health_threshold:
			# If player health is at or above the threshold for this heart,
			# it should be a full heart.
			hearts[i].texture = full_heart_texture
		elif health == heart_health_threshold - 1:
			# If player health is exactly one less than the threshold,
			# it's a half heart.
			hearts[i].texture = half_heart_texture
		else:
			# Otherwise, the heart is empty.
			hearts[i].texture = empty_heart_texture
