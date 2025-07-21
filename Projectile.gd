extends RigidBody2D

@export var move_speed := 1.0
@export var direction := Vector2(0,0)

func _physics_process(delta):
	
	var velocity = direction.normalized() * delta
	print(velocity)
	apply_force(velocity)
