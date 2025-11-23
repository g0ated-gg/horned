class_name Projectile extends CharacterBody3D

@export var direction: Vector3 = Vector3.ZERO
@export var speed: float = 5.0
@export var buffer: Array[Projectile]
@export var max_life_time: float = 5.0

var life_time: float = 0.0

func _physics_process(delta: float) -> void:
	if not visible:
		return
	if direction and life_time < max_life_time:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		life_time += delta
		var collision = move_and_collide(velocity * delta)
		if collision:
			var collider = collision.get_collider()
			if collider is Hero:
				(collider as Hero).die()
			if collider is Enemy:
				(collider as Enemy).hp -= 1
			if collider is Projectile:
				(collider as Projectile)._return_to_buffer()
			_return_to_buffer()
	else:
		_return_to_buffer()

func _return_to_buffer() -> void:
	visible = false
	var parent = get_parent_node_3d()
	if parent != null:
		parent.remove_child(self)
		buffer.append(self)
	life_time = 0.0
