extends CharacterBody2D

# Horizontal movement speed
@export var speed = 200.0

# Jump parameters
@export var max_jump_velocity = -400.0
@export var min_jump_velocity = -200.0
@export var jump_upward_acceleration = 2000.0  # Acceleration while holding jump
@export var gravity = 1000.0
@export var jump_gravity = 1000.0  # Gravity when not holding jump
@export var release_gravity = 1500.0  # Gravity when releasing jump button

# Timing parameters for variable jump
const MIN_JUMP_TIME = 0.05  # 50ms for minimum jump
const MAX_JUMP_TIME = 0.2   # 200ms for maximum jump

# Variables to track jump input timing
var jump_input_time = 0.0
var jump_key_held = false
var is_jumping = false

func _physics_process(delta):
	# Handle jump input timing
	if Input.is_action_just_pressed("JUMP") and is_on_floor():
		jump_key_held = true
		jump_input_time = 0.0
		is_jumping = true
		
		# Immediate minimal jump to avoid input lag
		velocity.y = min_jump_velocity
	
	if Input.is_action_just_released("JUMP"):
		jump_key_held = false
	
	# Apply jump acceleration while holding jump and within time window
	if is_jumping and jump_key_held and jump_input_time < MAX_JUMP_TIME:
		# Apply upward acceleration while holding jump button
		velocity.y += jump_upward_acceleration * delta
		print("Jump:", jump_input_time)
	
	# Update jump timer
	if is_jumping:
		jump_input_time += delta
		
		# Stop accelerating when time is up
		if jump_input_time >= MAX_JUMP_TIME:
			is_jumping = false
	
	# Apply gravity based on jump button state
	if not is_on_floor():
		if jump_key_held:
			velocity.y += jump_gravity * delta
			print("Jump hold:", jump_input_time)
		else:
			# print("Jump release:", jump_input_time)
			velocity.y += release_gravity * delta
	# else:
	# 	# Reset jump state when on floor
	# 	is_jumping = false
	
	# Handle horizontal movement
	var direction = Input.get_axis("MOVE_LEFT", "MOVE_RIGHT")
	if direction:
		velocity.x = direction * speed
	else:
		# Apply friction when no input
		velocity.x = move_toward(velocity.x, 0, speed)
	
	# Apply movement
	move_and_slide()