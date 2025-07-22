extends CharacterBody2D

var projectile = preload("res://Projectile.tscn")

@export var move_speed := 200.0

var ratelimit :=  Timer.new()

func _physics_process(delta):
	var direction = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up"),
		).normalized()
		
	velocity = direction * move_speed
	move_and_slide()
	
func fire(direction):
	if ratelimit.is_stopped:
		ratelimit.start(3)
		print("hi")
		var newprojectile = projectile.instantiate()
		newprojectile.direction = direction
		newprojectile.global_position = get_global_position()
		get_parent().add_child(newprojectile)
	
func _process(delta):
	if Input.is_action_pressed("shoot_down"):
		fire(Vector2(0,-1))
	if Input.is_action_pressed("shoot_up"):
		fire(Vector2(0,1))
	if Input.is_action_pressed("shoot_right"):
		fire(Vector2(1,0))
	if Input.is_action_pressed("shoot_left"):
		fire(Vector2(-1,0))
