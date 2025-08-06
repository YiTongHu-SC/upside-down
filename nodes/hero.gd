extends CharacterBody2D

@export var explosion: PackedScene
@export var physics_unit = 100
# Horizontal movement move_speed
@export var move_speed = 2.0
@export var friction = 10.0
# Jump parameters
@export var switch_jump_velocity = 5
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

@onready var is_dead = false
@onready var upside_down: bool = false
@onready var facing = Face.RIGHT
@onready var current_state = State.IDLE
@onready var animation = $AnimationPlayer
@onready var gravity_dir = 1
@onready var particles_walk: GPUParticles2D = $GPUParticlesWalk
@onready var particles_dash: GPUParticles2D = $GPUParticlesDash

var init_pos: Vector2
func _ready():
	init_pos = position
	GameDataGlobal.on_game_restart.connect(reset)
	# Set initial jump state
	is_jumping = false
	animation.play("idle")
	add_to_group("hero")

func _physics_process(delta):
	if GameDataGlobal.game_paused: return

	if Input.is_action_just_pressed("DASH"):
		upside_down = !upside_down
		gravity_dir = - gravity_dir
		up_direction = Vector2(0, -gravity_dir)
		flip_y()
		# 给一个大速度
		velocity.y = switch_jump_velocity * physics_unit * gravity_dir
		GameDataGlobal.on_upside_down.emit(upside_down)
		particles_dash.emitting = true
		pass

	# Handle jump input timing
	if Input.is_action_just_pressed("JUMP") and is_on_floor():
		jump_key_held = true
		jump_input_time = 0.0
		is_jumping = true
		animation.play("jump")
		current_state = State.JUMP

		# Immediate minimal jump to avoid input lag
		velocity.y = - min_jump_velocity * physics_unit * gravity_dir
	
	if Input.is_action_just_released("JUMP"):
		jump_key_held = false
	
	# Apply jump acceleration while holding jump and within time window
	if is_jumping and jump_key_held and jump_input_time < MAX_JUMP_TIME:
		# Apply upward acceleration while holding jump button
		velocity.y -= jump_upward_acceleration * physics_unit * delta * gravity_dir
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
			velocity.y += jump_gravity * physics_unit * delta * gravity_dir
			# print("Jump hold:", jump_input_time)
		else:
			# print("Jump release:", jump_input_time)
			velocity.y += release_gravity * physics_unit * delta * gravity_dir
	# else:
	# 	# Reset jump state when on floor
	# 	is_jumping = false
	
	# Handle horizontal movement
	var direction = Input.get_axis("MOVE_LEFT", "MOVE_RIGHT")
	if direction:
		if current_state != State.WALK && not is_jumping:
			animation.play("walk")
			current_state = State.WALK
			particles_walk.emitting = true
		velocity.x = direction * move_speed * physics_unit
		_update_face(direction)
	else:
		if current_state != State.IDLE && not is_jumping:
			animation.play("idle")
			current_state = State.IDLE
			particles_walk.emitting = false
		# Apply friction when no input
		velocity.x = move_toward(velocity.x, 0, friction * physics_unit * delta)

	# Apply movement
	move_and_slide()
	check_collision()

enum Face {
	LEFT,
	RIGHT
}

func _update_face(dir: float):
	## check facing
	if dir < -0.5 && facing != Face.LEFT:
		facing = Face.LEFT
		flip_x()
	elif dir > 0.5 && facing != Face.RIGHT:
		facing = Face.RIGHT
		flip_x()

func flip_x():
	scale.x = -1

func flip_y():
	scale.y *= -1

func check_collision():
	if GameDataGlobal.game_paused: return
	if is_dead: return
	# 检查碰撞
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider and (collider.is_in_group("enemy") or collider.is_in_group("trap")):
			_on_hero_collision_boss()
		if collider and collider.is_in_group("finish"):
			_game_success()

func _on_hero_collision_boss():
	is_dead = true
	print("hero collision")
	GameDataGlobal.on_game_over.emit()
	kill_self()

func reset():
	print("hero reset")
	pass

func kill_self():
	var explosion_instance = explosion.instantiate()
	get_parent().add_child(explosion_instance)
	explosion_instance.global_position = global_position
	queue_free()

func _game_success():
	GameDataGlobal.game_paused = true
	GameDataGlobal.on_game_success.emit()
