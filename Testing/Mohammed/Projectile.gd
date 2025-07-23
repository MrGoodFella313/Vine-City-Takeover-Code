extends RigidBody2D

@export var move_speed := 1000.0
@export var direction := Vector2(0,0)

func _ready():
	gravity_scale = 0

func _physics_process(delta):
	var linear_velocity = direction * move_speed
	#print(velocity)
	#apply_force(velocity)
