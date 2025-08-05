extends CharacterBody2D

signal health_changed(new_health)
signal kill_count_updated(current_kills, max_kills)

@export var max_health: int = 10
var current_health: int

#var projectile = preload("res://Testing/Mohammed/Projectile.tscn")
@export var regular_banana_scene: PackedScene
@export var fire_banana_scene: PackedScene 
var current_projectile_scene: PackedScene

@export var move_speed := 300.0
@export var shoot_cooldown := 0.2
@export var offset_distance := 80

var current_room: int = 1

var can_shoot = true
var shoot_timer: Timer

var is_fire_banana_mode: bool = false

# Variables for tracking game progress
var jaguars_killed_count: int = 0
const JAGUARS_TO_KILL: int = 6


func _ready():
	current_health = max_health
	health_changed.emit(current_health)
	set_process(true)
	shoot_timer = Timer.new()
	add_child(shoot_timer)
	shoot_timer.one_shot = true
	shoot_timer.timeout.connect(func(): can_shoot = true)

	current_projectile_scene = regular_banana_scene
	
	
	# Connect to the killed signal of all enemies in the "enemies" group.
	# NOTE: You MUST add your Jaguar enemy nodes to the "enemies" group in the Godot editor.
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy.has_signal("killed"):
			enemy.killed.connect(_on_jaguar_killed)

	kill_count_updated.emit(jaguars_killed_count, JAGUARS_TO_KILL)

# Player movement (WASD)
func _physics_process(delta):
	var direction = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up"),
		).normalized()
		
	velocity = direction * move_speed
	move_and_slide()
	
# Projectile spawns in whatever direction you press
func fire(direction, angle):
	if can_shoot:
		can_shoot = false
		shoot_timer.start(shoot_cooldown)
		var newprojectile = current_projectile_scene.instantiate()
		#print("Direction | ", direction)
		#print("Player Pos | ", position)
		var projectile_spawn = Vector2(position.x + direction.x ,position.y + direction.y)
		#print("Projectile Pos | ", newprojectile.global_position)
		#print("Spawn | ", projectile_spawn)
		newprojectile.direction = direction
		#var banana_rotation =
		#print("Before| ", newprojectile.rotation)
		newprojectile.rotation = angle;
		#print("After| ", newprojectile.rotation)
		newprojectile.global_position = projectile_spawn
		get_parent().add_child(newprojectile)
	
func _process(delta):
	var shoot_direction = Vector2.ZERO
	
	if Input.is_action_just_pressed("shoot_down"):
		#print("down")
		shoot_direction = (Vector2(0,offset_distance))
		fire(shoot_direction, 70)
		$Sprite2D.texture = load("res://Assets/Spites/monty with basic gun front face .png")
	
	elif Input.is_action_just_pressed("shoot_up"):
		#print("up")
		shoot_direction = (Vector2(0,- offset_distance))
		fire(shoot_direction, -90)
		$Sprite2D.texture = load("res://Assets/Spites/monty with gun back face .png")
		
	elif Input.is_action_just_pressed("shoot_right"):
		#print("right")
		shoot_direction = (Vector2(offset_distance,0))
		fire(shoot_direction, 0)
		$Sprite2D.texture = load("res://Assets/Spites/monty with basic gun right face .png")
		
	elif Input.is_action_just_pressed("shoot_left"):
		#print("left")
		shoot_direction = (Vector2(-offset_distance,0))
		fire(shoot_direction, -123)
		$Sprite2D.texture = load("res://Assets/Spites/Monty with basic gun left face.png")
		
		
	if Input.is_action_just_pressed("switch_bullet"):
		switch_projectile_type()

func take_damage(amount: int):
	current_health -= amount
	current_health = max(current_health, 0)
	health_changed.emit(current_health)
	
	print("Player took %d damage, health is now %d" % [amount, current_health])

	# TODO when the player dies pull up restart
	if current_health == 0:
		print("Player has died.")


func heal(amount: int):
	current_health += amount
	current_health = min(current_health, max_health)
	health_changed.emit(current_health)
	print("Player healed %d, health is now %d" % [amount, current_health])



# Test Function To remove later
#func _unhandled_input(event):
	#if event is InputEventKey and event.is_pressed() and not event.is_echo():
		#if event.keycode == KEY_V:
			#take_damage(2) # -1 heart (2 health points)
		#if event.keycode == KEY_B:
			#take_damage(1) # -0.5 heart (1 health point)
		#if event.keycode == KEY_N:
			#heal(1) # +0.5 heart (1 health point)
		#if event.keycode == KEY_M:
			#heal(2) # +1 heart (2 health points)
		#if event.keycode == KEY_H:
			## Set health directly to max and emit the signal
			#current_health = max_health
			#health_changed.emit(current_health)
			#print("Player health restored to maximum.")

func switch_projectile_type():
	is_fire_banana_mode = not is_fire_banana_mode

	if current_projectile_scene == regular_banana_scene:
		current_projectile_scene = fire_banana_scene
		print("Switched to Fire Banana!")
		
	else:
		current_projectile_scene = regular_banana_scene
		print("Switched to Regular Banana!")


func _on_jaguar_killed():
	jaguars_killed_count += 1
	print("Jaguar killed! Total killed: %d/%d" % [jaguars_killed_count, JAGUARS_TO_KILL])
	
	kill_count_updated.emit(jaguars_killed_count, JAGUARS_TO_KILL)
	
	if jaguars_killed_count >= JAGUARS_TO_KILL:
		print("You Win! You defeated all the jaguars!")
		get_tree().change_scene_to_file("res://Win_Screen.tscn")

		# Add game ending logic here

func update_room(room: int):
	current_room = room
	print("Room : ", current_room)
