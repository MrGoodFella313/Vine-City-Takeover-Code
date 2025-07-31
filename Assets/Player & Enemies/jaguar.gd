extends CharacterBody2D

signal killed

# Define the possible states for the enemy.
enum State { IDLE, CHASE, ATTACK, ATTACK_WINDUP, COOLDOWN }

@export var max_health: int = 3
var current_health: int

@export var speed: float = 125.0
@export var windup_duration: float = 0.5  # How long to wait before spinning.
@export var attack_duration: float = 1.5  # How long the spin attack lasts.
@export var cooldown_duration: float = 3.0 # How long to idle after an attack.
@export var rotation_speed: float = TAU # Speed of the spin attack.
@export var attack_damage: int = 1
var _theta : float

# Assign the player node in the inspector. The jaguar will chase this target.
@export var player_node_path: NodePath

var current_state: State = State.CHASE
var player_in_range: bool = false
var player_reference: Node2D = null

# Timers are now handled by variables.
var windup_time_left: float = 0.0
var attack_time_left: float = 0.0
var cooldown_time_left: float = 0.0

# Node references tha t you will assign in the editor or via @onready.
@onready var player_detector = $"Player Detector"   # Area2D to detect the player and trigger attack.
@onready var attack_hitbox = $TailHitbox       # Area2D for the spin attack damage.
@onready var hurtbox = $Hurtbox                 # Area2D for taking damage.

func _ready() -> void:
	
	current_health = max_health
	# Get a reference to the player node from the assigned path.
	player_reference = get_node_or_null(player_node_path)
	if not player_reference:
		print("Jaguar Error: Player node not assigned in the Inspector. Jaguar will be idle.")
		change_state(State.IDLE)
		return

	# Connect signals from child nodes to functions in this script.
	player_detector.body_entered.connect(_on_player_detector_body_entered)
	player_detector.body_exited.connect(_on_player_detector_body_exited)
	
	# The hurtbox checks for projectiles.
	hurtbox.area_entered.connect(_on_hurtbox_area_entered)
	
	attack_hitbox.body_entered.connect(_on_tail_hitbox_area_entered)
	
	# Set the initial state to CHASE.
	change_state(State.CHASE)


func _physics_process(delta: float) -> void:
	# The match statement runs the logic for the current state every frame.
	match current_state:
		State.IDLE:
			velocity = Vector2.ZERO
			
		State.CHASE:
			if player_reference:
				var direction = (player_reference.global_position - global_position).normalized()
				velocity = direction * speed
				_theta = wrapf(atan2(direction.y, direction.x) - rotation, -PI,PI)
				rotation += clamp(rotation_speed, 0, abs(_theta)) * sign(_theta)
			else:
				velocity = Vector2.ZERO

		State.ATTACK_WINDUP:
			velocity = Vector2.ZERO
			# Countdown the windup timer.
			windup_time_left -= delta
			if windup_time_left <= 0:
				change_state(State.ATTACK)
		
		State.ATTACK:
			
			velocity = Vector2.ZERO
			# Spin in place.
			rotation += (TAU / attack_duration) * delta
			# Countdown the attack timer.
			attack_time_left -= delta
			if attack_time_left <= 0:
				# When the attack is finished, disable the hitbox and enter cooldown.
				attack_hitbox.monitoring = false
				change_state(State.COOLDOWN)

		State.COOLDOWN:
			velocity = Vector2.ZERO
			# Countdown the cooldown timer.
			cooldown_time_left -= delta
			if cooldown_time_left <= 0:
				# After cooldown, check if the player is still in range to attack again.
				if player_in_range:
					change_state(State.ATTACK_WINDUP) # Attack again.
				else:
					change_state(State.CHASE) # Go back to chasing.
			
	move_and_slide()


func change_state(new_state: State) -> void:
	if current_state == new_state:
		return
	
	print("Jaguar state changed from %s to %s" % [State.keys()[current_state], State.keys()[new_state]])

	current_state = new_state
	
	match current_state:
		State.IDLE:
			rotation = 0
			# animation_player.play("idle")
			
		State.CHASE:
			# animation_player.play("chase")
			pass
		
		State.ATTACK_WINDUP:
			# Set the windup timer.
			windup_time_left = windup_duration
			# animation_player.play("attack_windup")
		State.ATTACK:
			# Set the attack timer and enable the hitbox.
			attack_time_left = attack_duration
			attack_hitbox.monitoring = true # Enable spin attack hitbox
			# animation_player.play("spin_attack")
			
		State.COOLDOWN:
			# Set the cooldown timer.
			cooldown_time_left = cooldown_duration
			# animation_player.play("idle")

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		if event.keycode == KEY_J:
			# Force the jaguar into the attack state for testing.
			change_state(State.ATTACK)

# --- Signal Handler Functions ---

func _on_player_detector_body_entered(body: Node) -> void:
	# Check if the body that entered is in the "player" group.
	if body.is_in_group("Monty"):
		player_in_range = true
		# If chasing, immediately attack.
		if current_state == State.CHASE:
			change_state(State.ATTACK_WINDUP)

func _on_player_detector_body_exited(body: Node) -> void:
	if body.is_in_group("Monty"):
		player_in_range = false
		# The state machine will transition to CHASE after the current action finishes.

func _on_hurtbox_area_entered(area: Area2D) -> void:
	print(area.get_groups())
	# Check if the area that hit the jaguar is in the "projectiles" group.
	if area.is_in_group("Projectile"):
		var damage_amount = 1
		
		if area.is_in_group("Fire"):
			damage_amount = 2
			print("Jaguar was hit by a FIRE projectile!")
		else: 
			print("Jaguar was hit by a REGULAR projectile!")
			
		take_damage(damage_amount)
		area.queue_free() # Destroy the projectile on hit.
		


func  take_damage(amount: int):
	current_health -= amount
	current_health = max(current_health, 0)
	
	print("Jaguar took %d damage, health is now %d" % [amount, current_health])
	
	if current_health <= 0:
		die()
		
		
func die():
	print("Jaguar Had Died!")
	# Before freeing the node, emit the signal to let others know it's been killed.
	killed.emit()
	queue_free()


func _on_tail_hitbox_area_entered(body: Node) -> void:
	if body.is_in_group("Monty"):
		# Ensure the jaguar is in an attacking state before dealing damage
		if current_state == State.ATTACK:
			if body.has_method("take_damage"):
				body.take_damage(attack_damage)
				#print("Jaguar hit the player for %d damage!" % attack_damage")
