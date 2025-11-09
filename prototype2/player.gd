class_name Player extends CharacterBody3D

@export var speed : float = 5.0
@export var look_direction: Vector3

func _physics_process(_delta: float) -> void:
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = -direction.x * speed
		velocity.z = -direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	var related_look_direction = position - look_direction
	if position != related_look_direction:
		look_at(related_look_direction)
	move_and_slide()
