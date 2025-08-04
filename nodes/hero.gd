extends CharacterBody2D

@export var physics_unit = 100
# Horizontal movement move_speed
@export var move_speed = 2.0

# Jump parameters
# @export var max_jump_velocity = -400.0
@export var min_jump_velocity = 2.0
@export var jump_upward_acceleration = 20.0 # Acceleration while holding jump
@export var jump_gravity = 10.0 # Gravity when not holding jump
@export var release_gravity = 15.0 # Gravity when releasing jump button

# Timing parameters for variable jump
const MIN_JUMP_TIME = 0.05 # 50ms for minimum jump
const MAX_JUMP_TIME = 0.2 # 200ms for maximum jump

# Variables to track jump input timing
var jump_input_time = 0.0
var jump_key_held = false
var is_jumping = false

enum State {
	IDLE,
	WALK,
	JUMP
}

@onready var facing = Face.RIGHT
@onready var current_state = State.IDLE
@onready var animation = $AnimationPlayer
func _ready():
	# Set initial jump state
	is_jumping = false
	animation.play("idle")

func _physics_process(delta):
	# Handle jump input timing
	if Input.is_action_just_pressed("JUMP") and is_on_floor():
		jump_key_held = true
		jump_input_time = 0.0
		is_jumping = true
		animation.play("jump")
		current_state = State.JUMP

		# Immediate minimal jump to avoid input lag
		velocity.y = - min_jump_velocity * physics_unit
	
	if Input.is_action_just_released("JUMP"):
		jump_key_held = false
	
	# Apply jump acceleration while holding jump and within time window
	if is_jumping and jump_key_held and jump_input_time < MAX_JUMP_TIME:
		# Apply upward acceleration while holding jump button
		velocity.y -= jump_upward_acceleration * physics_unit * delta
		# print("Jump:", jump_input_time)
	
	# Update jump timer
	if is_jumping:
		jump_input_time += delta
		
		# Stop accelerating when time is up
		if jump_input_time >= MAX_JUMP_TIME:
			is_jumping = false
	
	# Apply gravity based on jump button state
	if not is_on_floor():
		if jump_key_held:
			velocity.y += jump_gravity * physics_unit * delta
			# print("Jump hold:", jump_input_time)
		else:
			# print("Jump release:", jump_input_time)
			velocity.y += release_gravity * physics_unit * delta
	# else:
	# 	# Reset jump state when on floor
	# 	is_jumping = false
	
	# Handle horizontal movement
	var direction = Input.get_axis("MOVE_LEFT", "MOVE_RIGHT")
	print("direction", direction)
	if direction:
		if current_state != State.WALK && not is_jumping:
			animation.play("walk")
			current_state = State.WALK
		velocity.x = direction * move_speed * physics_unit
		_update_face(direction)
	else:
		if current_state != State.IDLE && not is_jumping:
			animation.play("idle")
			current_state = State.IDLE
		# Apply friction when no input
		velocity.x = move_toward(velocity.x, 0, move_speed * physics_unit)

	# Apply movement
	move_and_slide()

enum Face {
	LEFT,
	RIGHT
}

func _update_face(dir:float):
	## check facing
	if dir < -0.5 && facing != Face.LEFT:
		facing = Face.LEFT
		flip()
	elif dir > 0.5 && facing != Face.RIGHT:
		facing = Face.RIGHT
		flip()
func flip():
	scale.x = -1
