extends GPUParticles2D

@export var particles_lifetime = 0.5

func _ready():
	one_shot = true
	emitting = true
	await get_tree().create_timer(particles_lifetime).timeout
	queue_free()
