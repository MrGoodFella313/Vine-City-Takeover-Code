extends RigidBody2D

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
	queue_free()
	
	
