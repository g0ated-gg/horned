class_name Projectile extends CharacterBody3D

@export var direction : Vector2 = Vector2.ZERO
@export var speed : float = 5.0
@export var buffer : Array[Projectile]

func _physics_process(delta: float) -> void:
	if direction:
		velocity.x = direction.y * speed
		velocity.z = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	var collision = move_and_collide(velocity * delta)
	if collision:
		queue_free()
