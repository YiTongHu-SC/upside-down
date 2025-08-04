extends CharacterBody2D

# Horizontal movement speed
@export var speed = 200.0

# Jump velocity (negative because up is negative in Godot)
@export var  jump_velcity = -400.0

# Gravity value
@export var gravity = 1000.0

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Handle jump input
	if Input.is_action_just_pressed("JUMP") and is_on_floor():
		velocity.y = jump_velcity
	
	# Handle horizontal movement
	var direction = Input.get_axis("MOVE_LEFT", "MOVE_RIGHT")
	if direction:
		velocity.x = direction * speed
	else:
		# Apply friction when no input
		velocity.x = move_toward(velocity.x, 0, speed)
	
	# Apply movement
	move_and_slide()