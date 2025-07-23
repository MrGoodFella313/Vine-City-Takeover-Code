extends CharacterBody2D

var projectile = preload("res://Testing/Mohammed/Projectile.tscn")

@export var move_speed := 200.0
@export var shoot_cooldown := 0.3
@export var offset_distance := 80

var can_shoot = true
var shoot_timer: Timer

func _ready():
	set_process(true)
	shoot_timer = Timer.new()
	add_child(shoot_timer)
	shoot_timer.one_shot = true
	shoot_timer.timeout.connect(func(): can_shoot = true)

# Player movement (WASD)
func _physics_process(delta):
	var direction = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up"),
		).normalized()
		
	velocity = direction * move_speed
	move_and_slide()
	
# Projectile spawns in whatever direction you press
func fire(direction):
	if can_shoot:
		can_shoot = false
		shoot_timer.start(shoot_cooldown)
		var newprojectile = projectile.instantiate()
		#print("Direction | ", direction)
		#print("Player Pos | ", position)
		var projectile_spawn = Vector2(position.x + direction.x ,position.y + direction.y)
		#print("Projectile Pos | ", newprojectile.global_position)
		#print("Spawn | ", projectile_spawn)
		newprojectile.direction = direction
		
		newprojectile.global_position = projectile_spawn
		get_parent().add_child(newprojectile)
	
func _process(delta):
	var shoot_direction = Vector2.ZERO
	
	if Input.is_action_just_pressed("shoot_down"):
		#print("down")
		shoot_direction = (Vector2(0,offset_distance))
		fire(shoot_direction)
		
	elif Input.is_action_just_pressed("shoot_up"):
		#print("up")
		shoot_direction = (Vector2(0,- offset_distance))
		fire(shoot_direction)
		
	elif Input.is_action_just_pressed("shoot_right"):
		#print("right")
		shoot_direction = (Vector2(offset_distance,0))
		fire(shoot_direction)
		
	elif Input.is_action_just_pressed("shoot_left"):
		#print("left")
		shoot_direction = (Vector2(-offset_distance,0))
		fire(shoot_direction)
	
