extends CharacterBody2D

# Horizontal movement speed
@export var speed = 200.0

# Jump velocity (negative because up is negative in Godot)
@export var jump_velocity = -400.0

# Gravity value
@export var gravity = 1000.0

# Variable jump parameters
@export var min_jump_velocity = -200.0
@export var jump_buffer_time = 0.1
@export var coyote_time = 0.1

# Variables to track jump input timing
var jump_input_time = 0.0
var jump_key_held = false

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		# Reset jump input when on floor
		jump_input_time = 0.0
	
	# Handle jump input timing
	if Input.is_action_pressed("JUMP"):
		if Input.is_action_just_pressed("JUMP"):
			jump_key_held = true
			jump_input_time = 0.0
		elif jump_key_held:
			jump_input_time += delta
	elif Input.is_action_just_released("JUMP"):
		jump_key_held = false
	
	# Handle jump - higher jump when key held longer
	if jump_key_held and is_on_floor():
		# Calculate jump force based on how long the key has been held
		var jump_factor = clamp(jump_input_time / 0.3, 0.0, 1.0)
		velocity.y = lerp(jump_velocity, min_jump_velocity, jump_factor)
	elif not jump_key_held and not is_on_floor() and velocity.y < min_jump_velocity:
		# Limit jump height when key is released early
		velocity.y = min_jump_velocity
	
	# Handle horizontal movement
	var direction = Input.get_axis("MOVE_LEFT", "MOVE_RIGHT")
	if direction:
		velocity.x = direction * speed
	else:
		# Apply friction when no input
		velocity.x = move_toward(velocity.x, 0, speed)
	
	# Apply movement
	move_and_slide()